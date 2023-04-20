provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
}

module "test-vpc" {
    source = "./modules/vpc"
    aws_region = "us-east-1"
    vpc_cidr = "10.1.0.0/16"
    vpc_name = "MOD-TEST-VPC"
    IGW_name = "MOD-TEST-VPC-igw"
    Main_Routing_Table = "MOD-TEST-VPC_Public_Routing_Table"
    Private_Routing_Table = "MOD-TEST-VPC_Private_Routing_Table"
    environment = "TEST"
    azs = ["us-east-1a", "us-east-1b", "us-east-1c"]
    public_cidrs = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
    private_cidrs = ["10.1.10.0/24", "10.1.20.0/24", "10.1.30.0/24"]
}

module "test-ec2" {
    source = "./modules/ec2"
    instance_type = "t2.nano"
    environment = "${module.test-vpc.environment}"
    key_name = "LaptopKey"
    amis = {
            us-east-1 = "ami-0747bdcabd34c712a" # ubuntu 18.04 LTS
    		us-east-2 = "ami-0747bdcabd34c700a" # ubuntu 18.04 LTS
        }
    region = "${module.test-vpc.region}"
    vpc_name = "${module.test-vpc.vpc_id}"
    security_group = "${module.test-vpc.sg_id}"
    public-subnets = "${module.test-vpc.public_subnets}"
    iam_instance_profile = "${module.testenv_iam.instprofile}"
}

module "dev-vpc" {
    source = "./modules/vpc"
    aws_region = "us-east-1"
    vpc_cidr = "172.16.0.0/16"
    vpc_name = "MOD-DEV-VPC"
    IGW_name = "MOD-DEV-VPC-igw"
    Main_Routing_Table = "MOD-DEV-VPC_Public_Routing_Table"
    Private_Routing_Table = "MOD-DEV-VPC_Private_Routing_Table"
    environment = "DEV"
    azs = ["us-east-1a", "us-east-1b", "us-east-1c"]
    public_cidrs = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
    private_cidrs = ["172.16.10.0/24", "172.16.20.0/24", "172.16.30.0/24"]
}

module "dev-ec2" {
    source = "./modules/ec2"
    instance_type = "t2.nano"
    environment = "${module.dev-vpc.environment}"
    key_name = "LaptopKey"
    amis = {
            us-east-1 = "ami-0747bdcabd34c712a" # ubuntu 18.04 LTS
    		us-east-2 = "ami-0747bdcabd34c700a" # ubuntu 18.04 LTS
        }
    region = "${module.dev-vpc.region}"
    vpc_name = "${module.dev-vpc.vpc_id}"
    security_group = "${module.dev-vpc.sg_id}"
    public-subnets = "${module.dev-vpc.public_subnets}"
    iam_instance_profile = "${module.devenv_iam.instprofile}"
}