provider "aws" {
	#Credentials and region set in configuration directory
}

#######################################
#               SSH KEY               #
#######################################

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa ******" 
}

#######################################
#          EC2 INSTANCE(S)            #
#######################################

resource "aws_instance" "foo" {
  ami                         = "ami-123"
  instance_type               = "t2.micro"
  subnet_id                   = "${aws_subnet.foo-public-subnet.id}"
  key_name                    = "${aws_key_pair.deployer-key.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.https.id}"]
  associate_public_ip_address = False
  tags {
    Name = "Developement Front Server"
  }
}
resource "aws_instance" "foo-private" {
  ami                         = "ami-123"
  instance_type               = "t2.micro"
  subnet_id                   = "${aws_subnet.foo-private-subnet.id}"
  key_name                    = "${aws_key_pair.deployer-key.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.oracle.id}"]
  associate_public_ip_address = True
  tags {
    Name = "Developement Back Server"
  }
}


#######################################
#            EC2 SUBNET(S)            #
#######################################

resource "aws_subnet" "foo-public-subnet" {
  vpc_id = "${aws_vpc.foo-vpc.id}"
  cidr_block = "10.0.0.1/24"
  availability_zone = "eu-west-1a"
  tags {
    Name = "Developement Public Subnet"
  }
}
resource "aws_subnet" "foo-private-subnet" {
  vpc_id = "${aws_vpc.foo-vpc.id}"
  cidr_block = "10.0.0.2/24"
  availability_zone = "eu-west-1a"
  tags {
    Name = "Developement Private Subnet"
  }
}

#######################################
#        EC2 ROUTE TABLE(S)           #
#######################################

resource "aws_route_table" "foo-public-route" {
  vpc_id = "${aws_vpc.foo-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }
  tags {
    Name = "Public Route Table"
  }
}
resource "aws_route_table" "foo-private-route" {
  vpc_id = "${aws_vpc.foo-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_internet_gateway.default.id}"
  }
  tags {
    Name = "Private Route Table"
  }
}

#######################################
#      EC2 ROUTE ASSOCIATION(S)       #
#######################################

resource "aws_route_table_association" "foo-public-route-association" {
  subnet_id = "${aws_subnet.foo-public-subnet.id}"
  route_table_id = "${aws_route_table.foo-public-route.id}"
}
resource "aws_route_table_association" "foo-private-route-association" {
  subnet_id = "${aws_subnet.foo-private-subnet.id}"
  route_table_id = "${aws_route_table.foo-private-route.id}"
}
