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

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y apache2
              systemctl start apache2
              systemctl enable apache2
              EOF

  tags = {
    Name = "my-ec2-server"
  }
}