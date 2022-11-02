resource "aws_security_group" "db" {
  description = "Allows Postgres traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "db from vpc"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    description = "ssh from internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow postgres"
  }
}

resource "aws_instance" "db" {
  ami                         = data.aws_ami.amazon-2.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.db.id]
  subnet_id                   = aws_subnet.data_az1.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.deployer.id

  root_block_device {
    volume_size           = 50
    delete_on_termination = true
  }

  tags = {
    Name = "db"
  }
}
