locals {
  web_servers = {
    kwida-00 = {
      machine_type = "t2.micro"
      subnet_id    = aws_subnet.private_ap_southeast_1a.id
    }
    kwida-01 = {
      machine_type = "t2.micro"
      subnet_id    = aws_subnet.private_ap_southeast_1b.id
    }
  }
}

resource "aws_instance" "kwida" {
  for_each = local.web_servers

  ami               = var.i_ec2.ami
  instance_type     = each.value.machine_type
  key_name          = var.i_ec2.key_name
  subnet_id     = each.value.subnet_id

  vpc_security_group_ids = [aws_security_group.ec2_aps1.id]

  tags = {
    Name = each.key
  }
}