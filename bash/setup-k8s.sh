#!/bin/bash



# Setup SSH key login
mkdir /home/circlelabs/.ssh
chown circlelabs:circlelabs /home/circlelabs/.ssh
chmod 700 /home/circlelabs/.ssh

# cat pub key into authorized_keys
cat <<EOF | tee /home/circlelabs/.ssh/authorized_keys
<KEY_HERE>
EOF

# Set correct permissions for sshd
chown circlelabs:circlelabs /home/circlelabs/authorized_keys
chmod 600 /home/circlelabs/authorized_keys

# Turn off password authentication
sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config && sudo cat /etc/ssh/sshd_config
sudo systemctl restart sshd && sudo systemctl status sshd

# Package Installs
dnf makecache --refresh
sudo dnf update -y
sudo dnf install epel-release -y
sudo dnf install epel-next-release -y
sudo dnf install vim -y
sudo dnf install htop -y
sudo dnf install tar -y
sudo dnf install git -y
sudo dnf install wget -y
sudo dnf install net-tools -y
sudo dnf install telnet -y
sudo dnf install nc -y
sudo dnf install open-vm-tools -y
sudo setenforce 0
sudo sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config && cat /etc/selinux/config
sudo vim /etc/hosts
sudo init 6

###################################################################################
# begin kubernetes install
# run in root shell
###################################################################################

# kubernetes requires overlay and br_netfilter kernel modules
modprobe overlay
modprobe br_netfilter

# set k8s kernel module parameters
cat > /etc/modules-load.d/k8s.conf << EOF
overlay
br_netfilter 
EOF

# set parameters required by kubernetes
cat > /etc/sysctl.d/k8s.conf << EOF
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

# reload kernel parameter config files with above changes
sysctl --system

# recommended to turn swap off
swapoff -a
sed -e '/swap/s/^/#/g' -i /etc/fstab

# add containerd repo
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf makecache

# backup original containerd config and generate new file
mv /etc/containerd/config.toml /etc/containerd/config.toml.orig
containerd config default > /etc/containerd/config.toml

# edit containerd config and enable systemd cgroup networking driver
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml && cat /etc/containerd/config.toml

# enable and start caontainerd service
systemctl enable --now containerd.service
systemctl status containerd.service

# add required firewall rules and reload
firewall-cmd --permanent --add-port={6443,2379,2380,10250,10251,10252}/tcp
firewall-cmd --reload

# add official k8s repo to yum repo
cat > /etc/yum.repos.d/k8s.repo << EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

# build yum cache
dnf makecache

# install kubectl, kubeadm, kubelet
dnf install -y {kubelet,kubeadm,kubectl} --disableexcludes=kubernetes

# enable kubectl service
systemctl enable --now kubelet.service
systemctl status kubelet

# setup bash completion for kubectl
source <(kubectl completion bash)
kubectl completion bash > /etc/bash_completion.d/kubectl

# install flannel cni (container network interface) plugin. kubernetes requires a choice of 3rd party network plugins.
mkdir /opt/bin
curl -fsSLo /opt/bin/flanneld https://github.com/flannel-io/flannel/releases/download/v0.20.2/flannel-v0.20.2-linux-amd64.tar.gz
chmod +x /opt/bin/flanneld

# pull image stack that's required for the cluster
kubeadm config images pull

# initialize cluster
kubeadm init

# export admin.cong file variable for all sessions
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /etc/profile.d/k8s.sh

# run this as any system user and run next command to stand up kubernetes
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# stand up kube master node
kubeadm init --pod-network-cidr=10.244.0.0/16 --control-plane-endpoint=control-plane-node.circlelabs.home




# join worker node
kubeadm join 10.10.100.60:6443 --token z6iamh.gm3gujcec946yluw \
        --discovery-token-ca-cert-hash sha256:ca259415a846ccd78c918e4177187017353666298107b5b031a9e687b898c95c