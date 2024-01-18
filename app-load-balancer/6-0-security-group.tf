resource "aws_security_group" "ec2_aps1" {
  name   = "ec2-aps1"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group" "alb_aps1" {
  name   = "alb-aps1"
  vpc_id = aws_vpc.main.id
}
