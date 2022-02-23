resource "aws_vpc" "webserver" {
  cidr_block = "10.1.0.0/16"

}

resource "aws_subnet" "public-subnet" {
    vpc_id     = aws_vpc.webserver.id
    cidr_block = "10.1.1.0/24"
    availability_zone = "us-east-1a"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.webserver.id
}

resource "aws_route_table" "routetable" {
  vpc_id = aws_vpc.webserver.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
} 

resource "aws_route_table_association" "routetable-association" {
  route_table_id = aws_route_table.routetable.id
  subnet_id = aws_subnet.public-subnet.id

} 