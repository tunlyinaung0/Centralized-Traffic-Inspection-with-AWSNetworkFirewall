resource "aws_vpc" "security_vpc" {
    cidr_block = var.security_vpc_cidr

    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "Security_vpc"
    }
}


resource "aws_internet_gateway" "security_igw" {
    vpc_id = aws_vpc.security_vpc.id

    tags = {
        Name = "Security_igw"
    }
}

resource "aws_subnet" "security_public_subnet_a" {
    vpc_id = aws_vpc.security_vpc.id
    cidr_block = var.security_public_subnet_a
    availability_zone = var.az1

    tags = {
        Name = "security_public_subnet_a"
    }
}

resource "aws_subnet" "security_public_subnet_b" {
    vpc_id = aws_vpc.security_vpc.id
    cidr_block = var.security_public_subnet_b
    availability_zone = var.az2

    tags = {
        Name = "security_public_subnet_b"
    }
}


resource "aws_subnet" "tgw_subnet_a" {
    vpc_id = aws_vpc.security_vpc.id
    cidr_block = var.tgw_subnet_a
    availability_zone = var.az1

    tags = {
        Name = "tgw_subnet_a"
    }
}


resource "aws_subnet" "tgw_subnet_b" {
    vpc_id = aws_vpc.security_vpc.id
    cidr_block = var.tgw_subnet_b
    availability_zone = var.az2

    tags = {
        Name = "tgw_subnet_b"
    }
}


resource "aws_subnet" "firewall_subnet_a" {
    vpc_id = aws_vpc.security_vpc.id
    cidr_block = var.firewall_subnet_a
    availability_zone = var.az1

    tags = {
        Name = "firewall_subnet_a"
    }
}


resource "aws_subnet" "firewall_subnet_b" {
    vpc_id = aws_vpc.security_vpc.id
    cidr_block = var.firewall_subnet_b
    availability_zone = var.az2

    tags = {
        Name = "firewall_subnet_b"
    }
}

resource "aws_eip" "eip_a" {
    domain   = "vpc"

    tags = {
        Name = "eip_b"
    }
}

resource "aws_eip" "eip_b" {
    domain   = "vpc"

    tags = {
        Name = "eip_b"
    }
}


resource "aws_nat_gateway" "nat_a" {
    allocation_id = aws_eip.eip_a.id
    subnet_id     = aws_subnet.security_public_subnet_a.id

    tags = {
        Name = "NAT-A"
    }

    depends_on = [aws_internet_gateway.security_igw]
}


resource "aws_nat_gateway" "nat_b" {
    allocation_id = aws_eip.eip_b.id
    subnet_id     = aws_subnet.security_public_subnet_b.id

    tags = {
        Name = "NAT-B"
    }

    depends_on = [aws_internet_gateway.security_igw]
}

resource "aws_route_table" "public_rtb_a" {
    vpc_id = aws_vpc.security_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.security_igw.id
    }

    route {
        cidr_block = var.private_subnet_a_cidr
        vpc_endpoint_id = (aws_networkfirewall_firewall.network_firewall.firewall_status[0].sync_states[*].attachment[0].endpoint_id)[0]

    }

    route {
        cidr_block = var.private_subnet_b_cidr
        vpc_endpoint_id = (aws_networkfirewall_firewall.network_firewall.firewall_status[0].sync_states[*].attachment[0].endpoint_id)[0]

    }

    

    tags = {
        Name = "public_rtb_a"
    }
}


resource "aws_route_table" "public_rtb_b" {
    vpc_id = aws_vpc.security_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.security_igw.id
    }

    route {
        cidr_block = var.private_subnet_a_cidr
        vpc_endpoint_id = (aws_networkfirewall_firewall.network_firewall.firewall_status[0].sync_states[*].attachment[0].endpoint_id)[1]

    }

    route {
        cidr_block = var.private_subnet_b_cidr
        vpc_endpoint_id = (aws_networkfirewall_firewall.network_firewall.firewall_status[0].sync_states[*].attachment[0].endpoint_id)[1]

    }

    tags = {
        Name = "public_rtb_b"
    }
}


resource "aws_route_table" "firewall_rtb_a" {
    vpc_id = aws_vpc.security_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id =  aws_nat_gateway.nat_a.id
    }

    route {
        cidr_block = var.vpc_a_cidr
        transit_gateway_id = aws_ec2_transit_gateway.tgw.id
    }

    route {
        cidr_block = var.vpc_b_cidr
        transit_gateway_id = aws_ec2_transit_gateway.tgw.id
    }

    tags = {
        Name = "firewall_rtb_a"
    }
}


resource "aws_route_table" "firewall_rtb_b" {
    vpc_id = aws_vpc.security_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_b.id
    }

    route {
        cidr_block = var.vpc_a_cidr
        transit_gateway_id = aws_ec2_transit_gateway.tgw.id
    }

    route {
        cidr_block = var.vpc_b_cidr
        transit_gateway_id = aws_ec2_transit_gateway.tgw.id
    }

    tags = {
        Name = "firewall_rtb_b"
    }
}


resource "aws_route_table" "tgw_rtb_a" {
    vpc_id = aws_vpc.security_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        vpc_endpoint_id = (aws_networkfirewall_firewall.network_firewall.firewall_status[0].sync_states[*].attachment[0].endpoint_id)[0]
    }

    tags = {
        Name = "tgw_rtb_a"
    }
}


resource "aws_route_table" "tgw_rtb_b" {
    vpc_id = aws_vpc.security_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        vpc_endpoint_id = (aws_networkfirewall_firewall.network_firewall.firewall_status[0].sync_states[*].attachment[0].endpoint_id)[1]
    }

    tags = {
        Name = "tgw_rtb_b"
    }
}

resource "aws_route_table_association" "public_rtb_a_association" {
    subnet_id = aws_subnet.security_public_subnet_a.id
    route_table_id = aws_route_table.public_rtb_a.id
}

resource "aws_route_table_association" "public_rtb_b_association" {
    subnet_id = aws_subnet.security_public_subnet_b.id
    route_table_id = aws_route_table.public_rtb_b.id
}

resource "aws_route_table_association" "firewall_rtb_a_association" {
    subnet_id = aws_subnet.firewall_subnet_a.id
    route_table_id = aws_route_table.firewall_rtb_a.id
}

resource "aws_route_table_association" "firewall_rtb_b_association" {
    subnet_id = aws_subnet.firewall_subnet_b.id
    route_table_id = aws_route_table.firewall_rtb_b.id
}

resource "aws_route_table_association" "tgw_rtb_a_association" {
    subnet_id = aws_subnet.tgw_subnet_a.id
    route_table_id = aws_route_table.tgw_rtb_a.id
}

resource "aws_route_table_association" "tgw_rtb_b_association" {
    subnet_id = aws_subnet.tgw_subnet_b.id
    route_table_id = aws_route_table.tgw_rtb_b.id
}


resource "aws_default_security_group" "security_vpc_sg" {
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
        Name = "security_vpc_sg"
    }
}