## In this challenge i will use ansible for deploy on aws ec2

### Creating ec2 instance. 
i will use my my default sc group, subnet and my ssh key for fast deploymenet. 
```sh
aws ec2 run-instances \
  --image-id ami-0a5b5c0ea66ec560d \
  --count 1 \
  --instance-type t2.micro \
  --key-name mykey \
  --security-group-ids sg-095938d5e717361ea \
  --subnet-id subnet-02caf3f4a7dab08f6 \
  --region eu-central-1 > ec2-instance.json
```

### Geting ec2 instance public ip address
```sh
aws ec2 describe-instances | grep PublicIpAddress
```
### destroy instance
```sh
aws ec2 terminate-instances --instance-ids i-02fd91a672fb94864
```

### Connecting to ec2 instance
```sh
ssh -i ~/.aws/pems/mykey.pem admin@18.192.244.14
```

### prepare ec2 instance for become ansible node
```sh
# add new ansible user
adduser ansible

# permit ssh login with password. But i will close it that after ssh public key copied
sudo nano /etc/ssh/sshd_config
"PasswordAuthentication no" #<--- Change it w,th yes

# give sudo privileges to ansible user
sudo touch /etc/sudoers.d/ansible
"postgres ALL=(ALL) NOPASSWD:ALL" # <--- add into ansibe file

# restart ssh
sudo service ssh restart

# exit from ec2 instance
exit
```

# connect ec2 instance with ansible user
```sh
ssh ansible@18.192.244.14

# copy ssh publik key to ansible node
ssh-copy-id ansible@18.192.244.14
```

```sh
# connect to node with admin user
ssh -i ~/.aws/pems/mykey.pem admin@18.192.244.14

# disble password for ansible user
sudo usermod -L ansible

# disable password authentication to node
sudo nano /etc/ssh/sshd_config
"PasswordAuthentication yes" #<--- Change it with no
```

### Add host file node ip address
```sh
[group1]
ec2 ansible_host=18.192.244.14
```

### Create ansible config file. It is not mandotary but if you use, you will type short code every time.
```sh
[defaults]
inventory = hosts
private_key_file = ~/.ssh/ansible
remote_user = ansible
host_key_checking = False
```

### Lets check the connection with ansible ping module
```sh
ansible ec2 -m ping
```

```json
ec2 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
```

### run playbook
```sh
ansible-playbook playbook.yml
```

Finaly docker installed and images are running. You can check resultwith public ip address.

> http://18.192.244.14/