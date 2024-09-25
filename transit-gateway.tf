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
    subnet_ids = [ aws_subnet.tgw_subnet_a.id , aws_subnet.tgw_subnet_b.id ]
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
    appliance_mode_support = "enable"

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

resource "aws_ec2_transit_gateway_route" "ab_route" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.attachment_security.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.AB_tgw_rtb.id
}

resource "aws_ec2_transit_gateway_route" "security_route_a" {
  destination_cidr_block         = var.vpc_a_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.attachment_a.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.security_tgw_rtb.id
}

resource "aws_ec2_transit_gateway_route" "security_route_b" {
  destination_cidr_block         = var.vpc_b_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.attachment_b.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.security_tgw_rtb.id
}

resource "aws_ec2_transit_gateway_route_table_association" "rtb_association_a" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.attachment_a.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.AB_tgw_rtb.id
}

resource "aws_ec2_transit_gateway_route_table_association" "rtb_association_b" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.attachment_b.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.AB_tgw_rtb.id
}

resource "aws_ec2_transit_gateway_route_table_association" "security_rtb_association" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.attachment_security.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.security_tgw_rtb.id
}