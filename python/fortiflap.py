import requests
import urllib3
import json

# Suppress https insecure warnings
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# Set up the URL and headers for the API call
url = "https://10.13.37.2/api/v2/monitor/vpn/ipsec"
headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer d4n85k8bqw8080b56rgHGNh7bgNrNn"
}

# Make the GET request to retrieve the IPsec status
response = requests.get(url, headers=headers, verify=False)

# Check if the request was successful
if response.status_code != 200:
    print("Failed to retrieve IPsec status: " + response.text)
    exit()

# Parse the response data
data = json.loads(response.text)

# Check if the tunnel is down
tunnel_down = False
for tunnel in data['results']:
    if tunnel['name'] == "aws" and tunnel['proxyid'][0]['status'] == "down":
        tunnel_down = True
        break

# If the tunnel is down, disable and re-enable the associated tunnel interface
if tunnel_down:
    print('AWS Tunnel is DOWN')
    # Set the URL and payload for disabling the tunnel interface
    url = "https://10.13.37.2/api/v2/cmdb/system/interface/aws"
    data = {
        "status": "down"
    }

    # Make the PUT request to disable the tunnel interface
    response = requests.put(url, headers=headers, json=data, verify=False)

    # Check if the request was successful
    # if response.status_code == 200:
    if data['status'] == "down":
        print("AWS Tunnel interface disabled successfully")
    else:
        print("Failed to disable tunnel interface: " + data['status'])

    # Set the payload for re-enabling the tunnel interface
    data = {
        "status": "up"
    }

    # Make the PUT request to re-enable the tunnel interface
    response = requests.put(url, headers=headers, json=data, verify=False)

    # Check if the request was successful
    # if response.status_code == 200:
    if data['status'] == "up":
        print("AWS Tunnel interface re-enabled successfully")
    else:
        print("Failed to re-enable tunnel interface: " + data['status'])
else:
    print("Tunnel is not down, no action taken")
