module "jenkins" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins-tf"
  create_security_group = false
  instance_type          = "t3.small"
  vpc_security_group_ids = ["sg-012a82dc2ac8e30ea"] #replace your SG
  subnet_id = "subnet-0e33ccaf834d4a0c6" #replace your Subnet
  ami = data.aws_ami.ami_info.id
  user_data = file("jenkins.sh")
  tags = {
    Name = "jenkins-tf"
  }
}

module "jenkins_agent" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins-agent"
  create_security_group = false
  instance_type          = "t3.small"
  vpc_security_group_ids = ["sg-012a82dc2ac8e30ea"]
  # convert StringList to list and get first element
  subnet_id = "subnet-0e33ccaf834d4a0c6"
  ami = data.aws_ami.ami_info.id
  user_data = file("jenkins-agent.sh")
  tags = {
    Name = "jenkins-agent"
  }
}

module "nexus" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins-agent"
  create_security_group = false
  instance_type          = "t3.small"
  vpc_security_group_ids = ["sg-012a82dc2ac8e30ea"]
  # convert StringList to list and get first element
  subnet_id = "subnet-0e33ccaf834d4a0c6"
  ami = data.aws_ami.nexus_ami_info.id
  user_data = file("jenkins-agent.sh")
  tags = {
    Name = "nexus"
  }
}

resource "aws_route53_record" "jenkins" {
  zone_id = data.aws_route53_zone.zone_name.zone_id
  name    = "jenkins.sainath.online"
  type    = "A"
  ttl     = 1
  records = [module.jenkins.public_ip]
}

resource "aws_route53_record" "jenkins_agent" {
  zone_id = data.aws_route53_zone.zone_name.zone_id
  name    = "jenkins-agent.sainath.online"
  type    = "A"
  ttl     = 1
  records = [module.jenkins_agent.private_ip]
}

resource "aws_route53_record" "nexus" {
  zone_id = data.aws_route53_zone.zone_name.zone_id
  name    = "nexus.sainath.online"
  type    = "A"
  ttl     = 1
  records = [module.nexus.private_ip]
}