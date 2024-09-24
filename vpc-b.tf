resource "aws_vpc" "vpc_b" {
    cidr_block = var.vpc_b_cidr

    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "vpc-B"
    }
    
}

resource "aws_subnet" "private_subnet_b" {
    vpc_id = aws_vpc.vpc_b.id
    cidr_block = var.private_subnet_b_cidr
    availability_zone = var.az2

    tags = {
        Name = "private-subnet-b"
    }
}


resource "aws_route_table" "private_rtb_b" {
    vpc_id = aws_vpc.vpc_b.id

    tags = {
        Name = "private-rtb-b"
    }

}

resource "aws_route_table_association" "private_rtb_b_association" {
    subnet_id = aws_subnet.private_subnet_b.id
    route_table_id = aws_route_table.private_rtb_b.id
}

resource "aws_default_security_group" "vpc_b_sg" {
    vpc_id = aws_vpc.vpc_b.id

    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "vpc_b_sg"
    }
}