resource "aws_internet_gateway" "gateway" {
    vpc_id = aws_vpc.dojovpc.id
    tags = {
        Name = "vpc internet gateway dojo"
    }
}

resource "aws_route_table" "route" {
    vpc_id = aws_vpc.dojovpc.id
    tags = {
        Name = "gateway route public dojo"
    }
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.dojovpc.id
    tags = {
        Name = "gateway route private dojo"
    }
}

 resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
}

resource "aws_route" "private_nat_gateway_a" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_pub_a.id
}

resource "aws_route" "private_nat_gateway_b" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_pub_b.id
}

 resource "aws_route_table_association" "public_a" {
   subnet_id   = aws_subnet.subnet_a_public.id
   route_table_id = aws_route_table.route.id
}

resource "aws_route_table_association" "public_b" {
   subnet_id   = aws_subnet.subnet_b_public.id
   route_table_id = aws_route_table.route.id
}

resource "aws_eip" "gateway_a" {
  vpc        = true
  depends_on = [ aws_internet_gateway.gateway ]
}

resource "aws_eip" "gateway_b" {
  vpc        = true
  depends_on = [ aws_internet_gateway.gateway ]
}

resource "aws_nat_gateway" "nat_pub_a" {
  allocation_id = aws_eip.gateway_a.id
  subnet_id     = aws_subnet.subnet_a_public.id
  depends_on    = [ aws_internet_gateway.gateway ]
  tags = {
    Name        = "nat pub a"
    Environment = "training"
  }
}

resource "aws_nat_gateway" "nat_pub_b" {
  allocation_id = aws_eip.gateway_b.id
  subnet_id     = aws_subnet.subnet_b_public.id
  depends_on    = [ aws_internet_gateway.gateway ]
  tags = {
    Name        = "nat pub b"
    Environment = "training"
  }
}
