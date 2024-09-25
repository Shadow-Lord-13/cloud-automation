user_data = <<-EOF
    #!/bin/bash
    # Update the package repository and install dependencies
    sudo apt update -y
    sudo apt install -y openjdk-17-jre
    
    # Install Docker
    sudo apt install docker.io -y
    
    # Install Jenkins
    curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

    sudo apt-get update -y
    sudo apt-get install jenkins -y

    #Give jenkins and ubuntu user permission for docker deamon.
    #su -i
    sudo usermod -aG docker jenkins
    sudo usermod -aG docker ubuntu
    sudo systemctl restart docker
    sudo systemctl restart jenkins
EOF