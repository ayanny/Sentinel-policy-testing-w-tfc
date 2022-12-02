#Retrieve AMI data for EC2 provisioning
data "aws_ami" "latest-ubuntu" {
    most_recent = true
    owners = ["099720109477"]

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

resource "aws_instance" "web" {
    ami                         = data.aws_ami.latest-ubuntu.id
    instance_type               = var.webinstance
    user_data_base64            = data.cloudinit_config.webtemplate.rendered
    user_data_replace_on_change = true
    iam_instance_profile        = aws_iam_instance_profile.awsssm.id
    key_name                    = aws_key_pair.ec2_keypair.key_name
    vpc_security_group_ids      = [aws_security_group.allow_web.id]
    subnet_id                   = aws_subnet.web.id
    availability_zone           = data.aws_availability_zones.available.names[0]
    count                       = var.webapp

    tags = {
      Application = "web"
    }
} 

resource "aws_instance" "data" {
    ami                         = data.aws_ami.latest-ubuntu.id
    instance_type               = var.datainstance
    user_data_base64            = data.cloudinit_config.datatemplate.rendered
    user_data_replace_on_change = true
    iam_instance_profile        = aws_iam_instance_profile.awsssm.id
    key_name                    = aws_key_pair.ec2_keypair.key_name
    vpc_security_group_ids      = [aws_security_group.allow_data.id]
    subnet_id                   = aws_subnet.data.id
    availability_zone           = data.aws_availability_zones.available.names[0]
    count                       = var.dataapp

    tags = {
      Application = "data"
    }
}    
    

#Create and associate SSH Keys for EC2 instance
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "aws_key_pair" "ec2_keypair" {
  key_name   = "fakeservicekey"
  public_key = tls_private_key.ssh_key.public_key_openssh
}
  