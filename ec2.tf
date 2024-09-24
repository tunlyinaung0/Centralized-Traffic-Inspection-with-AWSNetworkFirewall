resource "aws_instance" "server_a" {
    ami = var.ami_id
    instance_type = var.instance_type
    availability_zone = var.az1
    iam_instance_profile = "SSM-for-ec2"
    subnet_id = aws_subnet.private_subnet_a.id
    vpc_security_group_ids = [aws_default_security_group.vpc_a_sg.id]

    tags = {
        Name = "Server-A"
    }

}

resource "aws_instance" "server_b" {
    ami = var.ami_id
    instance_type = var.instance_type
    availability_zone = var.az2
    iam_instance_profile = "SSM-for-ec2"
    subnet_id = aws_subnet.private_subnet_b.id
    vpc_security_group_ids = [aws_default_security_group.vpc_b_sg.id]

    tags = {
        Name = "Server-B"
    }

}