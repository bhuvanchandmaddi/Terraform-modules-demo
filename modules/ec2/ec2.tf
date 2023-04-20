resource "aws_instance" "public-servers" {
    count = "${var.environment == "DEV" ? 3 : 1}"
    ami = "${lookup(var.amis, var.region)}"
    instance_type = var.instance_type
    iam_instance_profile = var.iam_instance_profile
    key_name = var.key_name
    subnet_id = "${element(var.public-subnets, count.index)}"
    vpc_security_group_ids = [var.security_group]
    associate_public_ip_address = true	
    tags = {
        Name = "${var.vpc_name}-Public-Server-${count.index+1}"
        Env = "Prod"
        Owner = "Sreeharsha Veerapalli"
	    CostCenter = "ABCDEFG"
    }
    user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install -y nginx
    apt install -y jq
    service nginx start
    chkconfig httpd on
    echo "<h1>$(cat /etc/hostname)</h1>" >> /var/www/html/index.nginx-debian.html
    EOF
    
}


# resource "aws_instance" "private-servers" {
#     count = "${var.environment == "PROD" ? 3 : 1}"
#     ami = "${lookup(var.amis, var.aws_region)}"
#     instance_type = var.instance_type
#     key_name = var.key_name
#     subnet_id = "${element(aws_subnet.private-subnets.*.id, count.index)}"
#     vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
#     associate_public_ip_address = true	
#     tags = {
#         Name = "${var.vpc_name}-Private-Server-${count.index+1}"
#         Env = "Prod"
#         Owner = "Sree"
# 	    CostCenter = "ABCD"
#     }
# }