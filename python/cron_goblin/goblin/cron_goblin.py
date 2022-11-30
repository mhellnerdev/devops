#!/usr/bin/env python3
import os
import sys
import paramiko
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

# array of servers to grab crontab
server_list = [
    'host-01',
    'host-02',
    'host-03'
]

dirname = 'crondump'


def make_dir():
    try:
        os.mkdir(dirname)
        print(f"Directory {dirname} created!")
    except Exception as e:
        pass


def get_crontab():
    for server in server_list:
        try:
            # ssh connect to server
            ssh.connect(hostname=server,
                        username='cron_goblin', password='password', port=22)

            # get hostname and store in variable
            stdin, stdout, stderr = ssh.exec_command('hostname')
            hostname = stdout.read().decode("utf-8").strip('\n')

            # open sftp connection
            sftp_client = ssh.open_sftp()

            # get crontab file
            sftp_client.get(
                '/etc/crontab', f'{dirname}/crontab_{hostname}.cron')
            # sftp_client.get('/etc/crontab.daily', f'crontab.daily_{hostname}')

            # close ssh connection
            ssh.close()

            # print filename success
            print(f'{dirname}/crontab_{hostname}.cron')

        except Exception as e:
            print(f'THERE WAS AN ERROR WITH THIS HOST! {e}')
            pass


if __name__ == "__main__":
    make_dir()
    get_crontab()

# Bash commands to create cron_goblin user
# NOTE: Below commands will modify overall security of system allowing password authentication
# sudo sed -i s/'PasswordAuthentication no'/'PasswordAuthentication yes'/g /etc/ssh/sshd_config
# sudo systemctl restart sshd

# Below commands create user and set user's password to 'password'
# sudo adduser cron_goblin
# echo password | sudo passwd cron_goblin --stdin
