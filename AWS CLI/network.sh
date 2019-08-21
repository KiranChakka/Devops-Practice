1) Creation of vpc and subnet
vpc cidr: 10.10.0.0/16
subnet1 - 10.10.0.0/24
subnet2 - 10.10.1.0/24
subnet3 - 10.10.2.0/24
subnet4 - 10.10.3.0/24

aws ec2 create-vpc \
    --cidr-block 10.10.0.0/16
    
"VpcId": "vpc-018a8940ca6408b25"

aws ec2 create-subnet \
    --vpc-id vpc-018a8940ca6408b25 \
    --cidr-block 10.10.0.0/24\
    --availability-zone-id use2-az1

    "SubnetId": "subnet-0e4a18844e6e2ab45",

aws ec2 create-subnet \
    --vpc-id vpc-018a8940ca6408b25 \
    --cidr-block 10.10.1.0/24\
    --availability-zone-id use2-az2

       "SubnetId": "subnet-07bb0087f7250d706",

aws ec2 create-subnet \
    --vpc-id vpc-018a8940ca6408b25 \
    --cidr-block 10.10.2.0/24\
    --availability-zone-id use2-az3

     "SubnetId": "subnet-0b886ee3eeaffa366",

aws ec2 create-subnet \
    --vpc-id vpc-018a8940ca6408b25 \
    --cidr-block 10.10.3.0/24\
    --availability-zone-id use2-az3

 "SubnetId": "subnet-033628fee601b4731",
------------------------------------------------------------
2) Deletion of vpc and subnets

aws ec2 delete-subnet --subnet-id subnet-0976839aa9e832c22
aws ec2 delete-subnet --subnet-id subnet-061510fafd4c1d53f
aws ec2 delete-subnet --subnet-id subnet-08190b6b1fbab62e6
aws ec2 delete-subnet --subnet-id subnet-0192b074886a1c694

aws ec2 delete-vpc --vpc-id vpc-0ad830c53c8b15823
-------------------------------------------------------------------------
3) Creting and attaching igw to vpc
aws ec2 create-internet-gateway
"InternetGatewayId": "igw-0420ad6b29b76436e"
aws ec2 attach-internet-gateway --internet-gateway-id igw-0420ad6b29b76436e --vpc-id vpc-018a8940ca6408b25

4) Create route tables and ssociated to vpc

# create public route table
aws ec2 create-route-table --vpc-id vpc-018a8940ca6408b25

 "RouteTableId": "rtb-09aca669cdba2716a",

# create route 
aws ec2 create-route --route-table-id rtb-09aca669cdba2716a --destination-cidr-block 0.0.0.0/0 --gateway-id igw-0420ad6b29b76436e

# Associate subnets with the route tables
aws ec2 associate-route-table --route-table-id rtb-09aca669cdba2716a --subnet-id subnet-0e4a18844e6e2ab45
"AssociationId": "rtbassoc-018efb2fa7ffdbdcc"
aws ec2 associate-route-table --route-table-id rtb-09aca669cdba2716a --subnet-id subnet-07bb0087f7250d706
"AssociationId": "rtbassoc-04290d067d7553532"

# create private route table
aws ec2 create-route-table --vpc-id vpc-018a8940ca6408b25
"RouteTableId": "rtb-010bd9c1040cf1168",

# Associate subnets with the route tables
aws ec2 associate-route-table --route-table-id rtb-010bd9c1040cf1168 --subnet-id subnet-0b886ee3eeaffa366
"AssociationId": "rtbassoc-0564e0c8d968e2de7"
aws ec2 associate-route-table --route-table-id rtb-010bd9c1040cf1168 --subnet-id subnet-033628fee601b4731
"AssociationId": "rtbassoc-09db4460af3e09dac"

# create security group and associate allow rules for ports 22,80,443 for 0.0.0.0/0
aws ec2 create-security-group --group-name Allowssh --description "allow ssh http" --vpc-id vpc-018a8940ca6408b25
"GroupId": "sg-0fdb98f6c7ef87ef1"
aws ec2 authorize-security-group-ingress \
    --group-id sg-0fdb98f6c7ef87ef1 \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-id sg-0fdb98f6c7ef87ef1 \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-id sg-0fdb98f6c7ef87ef1 \
    --protocol tcp \
    --port 443 \
    --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress \
    --group-id sg-0fdb98f6c7ef87ef1 \
    --ip-permissions IpProtocol=icmp,FromPort=0,ToPort=100,IpRanges='[{CidrIp=0.0.0.0/0}]'

# create EC2 instance 
aws ec2 run-instances \
--image-id  ami-0d8f6eb4f641ef691 \
--instance-type t2.micro \
--key-name Maven \
--security-group-ids sg-0fdb98f6c7ef87ef1 \
--subnet-id subnet-0e4a18844e6e2ab45 \
--associate-public-ip-address

"InstanceId": "i-0c19a8849096a7c35",

aws ec2 run-instances \
--image-id  ami-0d8f6eb4f641ef691 \
--instance-type t2.micro \
--key-name Maven \
--security-group-ids sg-0fdb98f6c7ef87ef1 \
--subnet-id subnet-0b886ee3eeaffa366 

"InstanceId": "i-009c3940f570907b0",

--------------------------------------
aws ec2 terminate-instances --instance-ids i-009c3940f570907b0
aws ec2 terminate-instances --instance-ids i-0c19a8849096a7c35