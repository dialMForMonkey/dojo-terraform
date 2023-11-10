
resource "aws_subnet" "subnet_a_private" {
  vpc_id = aws_vpc.dojovpc.id
  cidr_block = "10.0.0.0/28"
  availability_zone = var.zones["west-a"]
}

resource "aws_subnet" "subnet_b_private" {
  vpc_id = aws_vpc.dojovpc.id
  cidr_block = "10.0.0.16/28"
  availability_zone = var.zones["west-b"]
}

resource "aws_subnet" "subnet_a_public" {
  vpc_id = aws_vpc.dojovpc.id
  cidr_block = "10.0.0.32/28"
  availability_zone = var.zones["west-a"]
}

resource "aws_subnet" "subnet_b_public" {
  vpc_id = aws_vpc.dojovpc.id
  cidr_block = "10.0.0.48/28"
  availability_zone = var.zones["west-b"]
}


resource "aws_security_group" "allow_http_public" {
  name        = "allow_http"
  description = "Allow http inbound/outbound traffic"
  vpc_id = aws_vpc.dojovpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  egress {
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_http_public"
  }
}

resource "aws_security_group" "allow_http_private" {
  name        = "allow_http_private "
  description = "Allow http inbound/outbound traffic"
  vpc_id = aws_vpc.dojovpc.id

  ingress {
    cidr_blocks = [aws_subnet.subnet_a_public.cidr_block, aws_subnet.subnet_b_public.cidr_block]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_http_private"
  }
}