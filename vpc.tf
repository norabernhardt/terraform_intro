resource "aws_vpc" "webserver" {
  cidr_block = "10.1.0.0/16"

}

resource "aws_subnet" "public-subnet" {
    vpc_id     = aws_vpc.webserver.id
    cidr_block = "10.1.1.0/24"
    availability_zone = "us-east-1a"
}