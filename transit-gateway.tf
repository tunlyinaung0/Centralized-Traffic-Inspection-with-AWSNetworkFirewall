resource "aws_ec2_transit_gateway" "tgw" {
    default_route_table_association = "disable"
    default_route_table_propagation = "disable"

    tags = {
        Name = "tgw"
    }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "attachment_a" {
    subnet_ids = [ aws_subnet.private_subnet_a.id ]
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
    vpc_id = aws_vpc.vpc_a.id

    tags = {
        Name = "tgw_attachment_A"
    }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "attachment_b" {
    subnet_ids = [ aws_subnet.private_subnet_b.id ]
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
    vpc_id = aws_vpc.vpc_b.id

    tags = {
        Name = "tgw_attachment_B"
    }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "attachment_security" {
    subnet_ids = [ aws_subnet.tgw_subnet_a, aws_subnet.tgw_subnet_b.id ]
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
    vpc_id = aws_vpc.security_vpc.id

    tags = {
        Name = "security_tgw_attachment"
    }
}

resource "aws_ec2_transit_gateway_route_table" "AB_tgw_rtb" {
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
    tags = {
        Name = "AB_tgw_rtb"
    }
}

resource "aws_ec2_transit_gateway_route_table" "security_tgw_rtb" {
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
    tags = {
        Name = "security_tgw_rtb"
    }
}

resource "aws_ec2_transit_gateway_route" "a_route" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.attachment_a
  transit_gateway_route_table_id = aws_ec2_transit_gateway.tgw.id
}

resource "aws_ec2_transit_gateway_route" "b_route" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.attachment_b
  transit_gateway_route_table_id = aws_ec2_transit_gateway.tgw.id
}