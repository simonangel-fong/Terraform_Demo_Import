resource "aws_vpc" "main" {
  count      = 2
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my-vpc-${count.index}"
  }
}

