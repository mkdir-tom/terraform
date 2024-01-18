resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "eip-${var.i_name_app}-nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_ap_southeast_1a.id

  tags = {
    Name = "${var.i_name_app}-nat-gateway"
  }

  depends_on = [aws_internet_gateway.igw]
}