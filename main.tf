# VPC $B$N:n@.(B
resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_block}"

  tags {
    Name = "${var.tag}"
  }
}

# Zone 1a $B$K(B DMZ subnet $B$r:n@.(B
resource "aws_subnet" "subnet1a_DMZ" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.vpc_subnet_1a_DMZ}"
  availability_zone = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.tag}"
  }
}

# Zone 1c $B$K(B DMZ subnet $B$r:n@.(B
resource "aws_subnet" "subnet1c_DMZ" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.vpc_subnet_1c_DMZ}"
  availability_zone = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.tag}"
  }
}

# internet gateway $B$N:n@.(B
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.tag}"
  }
}

# routing table $B$N:n@.(B
resource "aws_route_table" "routing" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "${var.tag}"
  }
}

# zone 1a $B$N(B DMZ subnet $B$K(B routing table $B$rE,MQ(B
resource "aws_route_table_association" "subnet1a_DMZ" {
  subnet_id = "${aws_subnet.subnet1a_DMZ.id}"
  route_table_id = "${aws_route_table.routing.id}"
}

# zone 1c $B$N(B DMZ subnet $B$K(B routing table $B$rE,MQ(B
resource "aws_route_table_association" "subnet1c_DMZ" {
  subnet_id = "${aws_subnet.subnet1c_DMZ.id}"
  route_table_id = "${aws_route_table.routing.id}"
}
