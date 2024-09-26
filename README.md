This project demonstates the how to use terraform, docker, Jenkins, AWS to set a autoated pipeline to run an python app.


Steps involved:

Run the below commands to install Java and Jenkins:

Install Java
'''
    sudo apt update
    sudo apt install openjdk-17-jre
'''

Verify Java is Installed
'''
    java -version
'''

Install Docker:
'''
    sudo apt install docker.io
'''

Now, you can proceed with installing Jenkins

'''
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins -y
'''

Note: use sudo cat var/.... to get the inital admin password


Install "docker pipeline" plugin in jenkins.

Grant Jenkins user and Ubuntu user permission to docker deamon.
'''
    sudo su - 
'''

Give jenkins and ubuntu user permission for docker deamon.
'''
    usermod -aG docker jenkins
    usermod -aG docker ubuntu
    systemctl restart docker
'''

Check if the user has access to docker deamon
'''
    sudo su - jenkins
    docker run hello-world
'''

Once you are done with the above steps, it is better to restart Jenkins.
'''
    http://<ec2-instance-public-ip>:8080/restart
'''


In case jenkins is failed to load follow below steps:

sudo nano /usr/lib/systemd/system/jenkins.service

Update in the file:
[Service]
TimeoutStartSec=600

After adding or modifying the line TimeoutStartSec=600 under the [Service] section, press:

Ctrl + O (this is "Write Out" to save the file).
Nano will ask for the filename to write, which should already be correct. Just press:

Enter to confirm.
After saving, exit nano by pressing:

Ctrl + X.

ubuntu@ip-172-31-93-174:~$ sudo systemctl daemon-reload
ubuntu@ip-172-31-93-174:~$ sudo systemctl restart jenkins


- Install ssh Agent plugin in jenkins.

Add credintils for ssh (shh private key content)
- 'ec2-ssh-credentials'

Add credintils for docker hub
- 'docker-credentials-id'
 - user name
 - password

- docker logs <container-id>
