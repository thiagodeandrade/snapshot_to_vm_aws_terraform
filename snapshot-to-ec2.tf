provider "aws" {
access_key = "xxxxxxxxxxxxxxxxx"
secret_key = "xxxxxxxxxxxxxxxx"

region = "us-east-1"
}

## Variables
#
variable "client" {
    type = "string"
    default = "clientburguer"
}
variable "mydnszone" {
    type = "string"
    default = "ZXXXXXX"
}
variable "clisnapshot" {
    type = "string"
    default = "snap-xxxxxxxx"
}
# Get Snapshot ID to restore a new Disk
resource "aws_ami" "client-ami" {
  name                = "client-ami"
  virtualization_type = "hvm"
  root_device_name    = "/dev/xvda"

  ebs_block_device {
    device_name = "/dev/xvda"
    # Last Snapshot ID from ClienteBurguer VM
    snapshot_id = "${var.clisnapshot}"
    volume_size = 20
  }
  tags = {
    Name  = "${var.client}-root-ami"
  }
}
# Create new VM from Snapshot
resource "aws_instance" "newserver" {
  ami           = "${aws_ami.client-ami.id}"
  instance_type = "t2.micro"
  key_name = "your_ssh_key"
  vpc_security_group_ids = [ "sg-xxxxx","sg-yyyyyy" ]

    tags = {
    Name  = "${var.client}-TEST"
  }
}
# Add public IP in domain yourdomain.net.br
#
resource "aws_eip" "default" {
  instance = "${aws_instance.newserver.id}"
  vpc = true
}
resource "aws_route53_record" "client-dns" {
  zone_id = "${var.myzonedns}"
  name    = "${var.client}"
  type    = "A"
  ttl     = "300"
  records = "${aws_instance.newserver.*.public_ip}"
}
