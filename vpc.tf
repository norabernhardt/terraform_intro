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

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow http traffic"
  vpc_id      = aws_vpc.webserver.id

  ingress {
    description = "Http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "webserver" {
  ami                         = "ami-033b95fb8079dc481"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public-subnet.id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.allow_http.id]
  user_data                   = file("userdata.sh")
}