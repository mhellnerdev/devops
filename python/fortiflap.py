#!/usr/bin/env python

import requests
import json

# Set up the URL and headers for the API call
url = "https://fortigate_ip/api/v2/monitor/vpn/ipsec"
headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer YOUR_API_TOKEN"
}

# Make the GET request to retrieve the IPsec status
response = requests.get(url, headers=headers)

# Check if the request was successful
if response.status_code != 200:
    print("Failed to retrieve IPsec status: " + response.text)
    exit()

# Parse the response data
data = json.loads(response.text)

# Check if the tunnel is down
tunnel_down = False
for tunnel in data['results']:
    if tunnel['name'] == "TUNNEL_NAME" and tunnel['status'] == "down":
        tunnel_down = True
        break

# If the tunnel is down, disable and re-enable the associated tunnel interface
if tunnel_down:
    # Set the URL and payload for disabling the tunnel interface
    url = "https://fortigate_ip/api/v2/cmdb/vpn/ipsec/phase1-interface/{tunnel_interface_name}"
    data = {
        "status": "disable"
    }

    # Make the PUT request to disable the tunnel interface
    response = requests.put(url, headers=headers, json=data)

    # Check if the request was successful
    if response.status_code == 200:
        print("Tunnel interface disabled successfully")
    else:
        print("Failed to disable tunnel interface: " + response.text)

    # Set the payload for re-enabling the tunnel interface
    data = {
        "status": "enable"
    }

    # Make the PUT request to re-enable the tunnel interface
    response = requests.put(url, headers=headers, json=data)

    # Check if the request was successful
    if response.status_code == 200:
        print("Tunnel interface re-enabled successfully")
    else:
        print("Failed to re-enable tunnel interface: " + response.text)
else:
    print("Tunnel is not down, no action taken")