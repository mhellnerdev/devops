#!/usr/bin/env python3

from paramiko import SSHClient
from scp import SCPClient

server_list = [
    '54.172.198.252',
    '3.86.81.175',
    '3.87.189.95',
]


for server in server_list:
    ssh = SSHClient()
    ssh.load_host_keys('xxxxxx')
    ssh.connect(
        '54.172.198.252',
        username='ec2-user',
        key_filename=)
    # SCPCLient takes a paramiko transport as an argument
    scp = SCPClient(ssh.get_transport())
    # scp.put('test.txt', 'test2.txt')
    scp.get('/etc/crontab', '/etc/crontab.daily')
    # Uploading the 'test' directory with its content in the '/home/user/dump' remote directory
    # scp.put('test', recursive=True, remote_path='/tmp')
    scp.close()
