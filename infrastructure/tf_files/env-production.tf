provider "aws" {
}

resource "aws_instance" "foo" {
  ami                         = "foo"
  instance_type               = "t2.micro"
  subnet_id                   = "${aws_subnet.prod-public.id}"
  key_name                    = "${aws_key_pair..key_name}"
  vpc_security_group_ids      = ["${aws_security_group.https.id}"]
  associate_public_ip_address = false
  tags {
    Name = "Prod Front Server"
  }
}
resource "aws_instance" "foo-private" {
  ami                         = "foo"
  instance_type               = "t2.micro"
  subnet_id                   = "${aws_subnet.prod-private.id}"
  key_name                    = "${aws_key_pair..key_name}"
  vpc_security_group_ids      = ["${aws_security_group.oracle.id}"]
  associate_public_ip_address = true
  tags {
    Name = "Prod Back Server"
  }
}
