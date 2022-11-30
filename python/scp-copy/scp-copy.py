#!/usr/bin/env python3

import paramiko
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

# array of servers to grab crontab
server_list = [
    'host-01',
    'host-02'
]


def get_crontab():
    for server in server_list:
        ssh.connect(hostname=server,
                    username='cron_goblin', password='password', port=22)
        stdin, stdout, stderr = ssh.exec_command('hostname')
        hostname = stdout.read().decode("utf-8").strip('\n')
        sftp_client = ssh.open_sftp()

        sftp_client.get('/etc/crontab', f'crontab_{hostname}')
        # sftp_client.get('/etc/crontab.daily', f'crontab.daily_{hostname}')

        ssh.close()


if __name__ == "__main__":
    get_crontab()

# Bash commands to create cron_goblin user
# NOTE: Below commands will modify overall security of system allowing password authentication
# sudo sed -i s/'PasswordAuthentication no'/'PasswordAuthentication yes'/g /etc/ssh/sshd_config
# sudo systemctl restart sshd

# Below commands create user and set user's password to 'password'
# sudo adduser cron_goblin
# echo password | sudo passwd cron_goblin --stdin
