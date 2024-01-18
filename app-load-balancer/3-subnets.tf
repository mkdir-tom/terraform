resource "aws_subnet" "private_ap_southeast_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/19"
  availability_zone = "ap-southeast-1a"

  tags = {
    "Name" = "private-${var.i_name_app}-ap-southeast-1a"
  }
}

resource "aws_subnet" "private_ap_southeast_1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/19"
  availability_zone = "ap-southeast-1b"

  tags = {
    "Name" = "private-${var.i_name_app}-ap-southeast-1b"
  }
}

resource "aws_subnet" "public_ap_southeast_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.64.0/19"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "public-${var.i_name_app}-ap-southeast-1a"
  }
}

resource "aws_subnet" "public_ap_southeast_1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.96.0/19"
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "public-${var.i_name_app}-ap-southeast-1b"
  }
}