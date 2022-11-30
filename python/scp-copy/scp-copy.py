#!/usr/bin/env python3

import paramiko
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

server_list = [
    '54.160.164.195',
    '3.208.25.76'
]

for server in server_list:
    ssh.connect(hostname=server,
                username='cron_goblin', password='password', port=22)
    stdin, stdout, stderr = ssh.exec_command('hostname')
    hostname = stdout.read().decode("utf-8").strip('\n')
    sftp_client = ssh.open_sftp()

    sftp_client.get('/etc/crontab', f'crontab_{hostname}')

    ssh.close()


# Bash commands to create cron_goblin user
# sudo adduser cron_goblin
# echo password | sudo passwd cron_goblin --stdin
