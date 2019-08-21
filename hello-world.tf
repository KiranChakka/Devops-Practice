provider "aws" {
  region     = "us-east-2"
  access_key = "enter the secret key"
  secret_key = "enter the secret key"
}

resource "aws_instance" "web" {
   ami           = "ami-0986c2ac728528ac2"
   instance_type = "t2.micro"
   key_name      = "Maven"
   security_groups = ["launch-wizard-3"]
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"
  # update aws_vpc.main.id with defaultvpc id by logging into aws console

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = ["pl-12c4e678"]
  }
}