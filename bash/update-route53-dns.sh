#!/bin/bash

# Script intended to be run on a cron
# * * * * * /usr/local/bin/update_dns.sh >/dev/null 2>&1

#Variable Declaration - Change These
HOSTED_ZONE_ID="xxxxxxxxxxxxxxxxxxx"
NAME="example.com."
TYPE="A"
TTL=60

#get current IP address
IP=$(/usr/bin/curl ip.me)

#validate IP address (makes sure Route 53 doesn't get updated with a malformed payload)
if [[ ! $IP =~ ^[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}$ ]]; then
        exit 1
fi

#get current
/usr/local/bin/aws route53 list-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID | jq -r '.ResourceRecordSets[] | select (.Name == "'"$NAME"'") | select (.Type == "'"$TYPE"'") | .ResourceRecords[0].Value' > /tmp/current_route53_value

cat /tmp/current_route53_value

#check if IP is different from Route 53
if grep -Fxq "$IP" /tmp/current_route53_value; then
        echo "IP Has Not Changed, Exiting"
        exit 1
fi


echo "IP Changed, Updating Records"

#prepare route 53 payload
cat > /tmp/route53_changes.json << EOF
    {
      "Comment":"Updated From DDNS Shell Script",
      "Changes":[
        {
          "Action":"UPSERT",
          "ResourceRecordSet":{
            "ResourceRecords":[
              {
                "Value":"$IP"
              }
            ],
            "Name":"$NAME",
            "Type":"$TYPE",
            "TTL":$TTL
          }
        }
      ]
    }
EOF

#update records
/usr/local/bin/aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch file:///tmp/route53_changes.json >> /dev/null