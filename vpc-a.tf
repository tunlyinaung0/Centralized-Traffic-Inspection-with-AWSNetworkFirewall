resource "aws_vpc" "vpc_a" {
    cidr_block = var.vpc_a_cidr

    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "vpc-A"
    }
    
}

resource "aws_subnet" "private_subnet_a" {
    vpc_id = aws_vpc.vpc_a.id
    cidr_block = var.private_subnet_a_cidr
    availability_zone = var.az1

    tags = {
        Name = "private-subnet-a"
    }
}


resource "aws_route_table" "private_rtb_a" {
    vpc_id = aws_vpc.vpc_a.id

    route {
        cidr_block = "0.0.0.0/0"
        transit_gateway_id = aws_ec2_transit_gateway.tgw.id
    }

    tags = {
        Name = "private-rtb-a"
    }

}

resource "aws_route_table_association" "private_rtb_a_association" {
    subnet_id = aws_subnet.private_subnet_a.id
    route_table_id = aws_route_table.private_rtb_a.id
}

resource "aws_default_security_group" "vpc_a_sg" {
    vpc_id = aws_vpc.vpc_a.id

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
        Name = "vpc_a_sg"
    }
}