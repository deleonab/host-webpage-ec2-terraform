data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "website" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.my_instance_SG ]
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y apache2 git
              systemctl start apache2
              systemctl enable apache2
              git clone https://github.com/deleonab/host-webpage-ec2-terraform.git /tmp/host-webpage-ec2-terraform 
              sudo mv /tmp/host-webpage-ec2-terraform/index.html /var/www/html/
              sudo chown www-data:www-data /var/www/html/index.html  # Change ownership to the web server user/group 
              EOF

  tags = {
    Name = "my-ec2-server"
  }
}