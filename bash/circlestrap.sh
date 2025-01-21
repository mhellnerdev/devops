#!/bin/bash

# Detect Linux distribution
source /etc/os-release

echo "Detected distribution: $ID"

# Common configuration: Set hostname
echo "Enter hostname:"
read hostname
hostnamectl set-hostname $hostname

# Function to configure DHCP
configure_dhcp() {
    if [[ -f /etc/netplan/01-netcfg-dhcp.yaml.backup ]]; then
        echo "Applying DHCP configuration from backup."
        sudo cp /etc/netplan/01-netcfg-dhcp.yaml.backup /etc/netplan/01-netcfg.yaml
        sudo netplan apply
        if [[ $? -ne 0 ]]; then
            echo "Failed to apply DHCP configuration. Exiting script."
            exit 1
        fi
        echo "DHCP configuration applied successfully."
    else
        echo "DHCP configuration backup not found. Cannot proceed with DHCP. Exiting script."
        exit 1
    fi
}

# Function to configure static IP
configure_static_ip() {
    echo "Enter IP address (e.g., 192.168.1.10/24):"
    read ip_address
    echo "Enter gateway:"
    read gateway
    default_interface=$(ip link show | awk -F: '/^[0-9]+: ens3/ {print $2}' | xargs)

    if [[ -n "$default_interface" ]]; then
        echo "Detected default interface: $default_interface"
        echo "Is this the correct interface? (yes/no)"
        read confirmation
        if [[ "$confirmation" != "yes" ]]; then
            echo "Available interfaces:"
            ip link show | awk -F: '/^[0-9]+: / {print $2}' | grep -v '^lo$'
            echo "Enter the correct interface name:"
            read interface
        else
            interface=$default_interface
        fi
    else
        echo "No default interface detected. Available interfaces:"
        ip link show | awk -F: '/^[0-9]+: / {print $2}' | grep -v '^lo$'
        echo "Enter the correct interface name:"
        read interface
    fi
    echo "Enter DNS Servers separated by a space:"
    read -a dns_servers

    if [[ "$ID" == "ubuntu" ]]; then
        echo "Setting up networking for Ubuntu"

        # Ensure a clean configuration by removing or ignoring existing files
        netplan_config="/etc/netplan/01-netcfg.yaml"

        for file in /etc/netplan/*.yaml; do
            if [[ "$file" != *".backup" ]]; then
                echo "Backing up existing Netplan configuration: $file"
                sudo mv "$file" "$file.backup"
            fi
        done

        # Ensure the new file exists and has proper permissions
        sudo touch $netplan_config
        sudo chmod 600 $netplan_config

        # Ubuntu network configuration using netplan
        cat <<EOF | sudo tee $netplan_config
network:
  version: 2
  renderer: networkd
  ethernets:
    $interface:
      addresses:
        - $ip_address
      routes:
        - to: default
          via: $gateway
      nameservers:
        addresses:
$(printf "          - %s\n" "${dns_servers[@]}")
EOF
        echo "Do you want to apply the network configuration and continue? (yes/no)"
        read confirmation
        if [[ "$confirmation" != "yes" ]]; then
            echo "Aborting script as per user request."
            exit 1
        fi

        sudo netplan apply
        if [[ $? -ne 0 ]]; then
            echo "Netplan apply failed. Exiting script."
            exit 1
        fi

        # Unmask wait-online service if it was previously masked
        sudo systemctl unmask systemd-networkd-wait-online.service
    elif [[ "$ID" =~ (rhel|centos|fedora|rocky) ]]; then
        echo "Setting up networking for RHEL-based distro"
        nmcli connection add type ethernet con-name ${interface}-connection ifname $interface
        nmcli connection modify ${interface}-connection ipv4.method manual ipv4.addresses $ip_address ipv4.gateway $gateway ipv4.dns "${dns_servers[*]}"
        nmcli connection up ${interface}-connection
    else
        echo "Unsupported distribution: $ID"
        exit 1
    fi
}

# Prompt user to enable DHCP or configure static IP
echo "Do you want to enable DHCP for the IP address? (yes/no)"
read enable_dhcp

if [[ "$enable_dhcp" == "yes" ]]; then
    configure_dhcp
else
    configure_static_ip
fi


# Setup hosts file
cat <<EOF | sudo tee /etc/hosts
127.0.0.1   $hostname
EOF

# Set up SSH authorized hosts for root
sudo mkdir -p /root/.ssh
sudo chmod 700 /root/.ssh
sudo touch /root/.ssh/authorized_keys
sudo chmod 600 /root/.ssh/authorized_keys

# Add root public key
cat <<EOF | sudo tee /root/.ssh/authorized_keys
ssh-rsa xxxxxxxxxxxxxxxxxxxx
EOF

# Ensure circlelabs user exists and set up SSH for it
if ! id -u circlelabs >/dev/null 2>&1; then
    sudo useradd -m -s /bin/bash circlelabs
fi

sudo mkdir -p /home/circlelabs/.ssh
sudo chmod 700 /home/circlelabs/.ssh
sudo touch /home/circlelabs/.ssh/authorized_keys
sudo chmod 600 /home/circlelabs/.ssh/authorized_keys

# Add the same key for circlelabs user
cat <<EOF | sudo tee /home/circlelabs/.ssh/authorized_keys
ssh-rsa xxxxxxxxxxxxxxxxxxxx
EOF

sudo chown -R circlelabs:circlelabs /home/circlelabs/.ssh

# Ensure circlelabs is in sudoers file without password prompt
echo "circlelabs ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/circlelabs
sudo chmod 440 /etc/sudoers.d/circlelabs

# Restart SSH
if [[ "$ID" == "ubuntu" ]]; then
    sudo systemctl restart ssh
else
    sudo systemctl restart sshd
fi

# Update package manager
if [[ "$ID" == "ubuntu" ]]; then
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt install -y vim htop tar git wget net-tools telnet
    sudo ufw disable
elif [[ "$ID" =~ (rhel|centos|fedora|rocky) ]]; then
    sudo dnf makecache --refresh
    sudo dnf update -y
    sudo dnf install -y vim htop tar git wget net-tools telnet
    sudo systemctl disable firewalld --now
fi

# Add additional package installs
echo "Enter any necessary package installs separated by a space:"
read -a packages
if [[ "$ID" == "ubuntu" ]]; then
    sudo apt install -y "${packages[@]}"
elif [[ "$ID" =~ (rhel|centos|fedora|rocky) ]]; then
    sudo dnf install -y "${packages[@]}"
fi

echo "Your box has been strapped."
echo "You can access it now at $ip_address or $hostname via ssh."
