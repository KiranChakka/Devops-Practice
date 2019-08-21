# Creation of db subnet
aws rds create-db-subnet-group \
    --db-subnet-group-name "dbcli1" \
    --db-subnet-group-description "created for db demo instance" \
    --subnet-ids "subnet-0b886ee3eeaffa366" "subnet-07bb0087f7250d706"
    
------------------------------------------------------------------
# creation of db security group
aws rds create-db-security-group \
    --db-security-group-name dbsecgroup \
    --db-security-group-description "Db Security Group"

aws rds  delete-db-security-group --db-security-group-name dbsecgroup
---------------------------------------------------------------------------

# creation vpc security group
aws ec2 create-security-group --group-name dbsecgroup --description "dbseccurity group to allow all" --vpc-id vpc-018a8940ca6408b25
"GroupId": "sg-09d256582b689c8f7"
aws ec2 authorize-security-group-ingress \
    --group-id sg-09d256582b689c8f7 \
    --protocol tcp \
    --port 0-65535 \
    --cidr 0.0.0.0/0

# Creation of db instance
aws rds create-db-instance \
    --db-name demosqldb \
    --db-instance-identifier "demodb" \
    --allocated-storage 20 \
    --db-instance-class db.t2.micro \
    --engine mysql \
    --master-username root \
    --master-user-password rootroot \
    --vpc-security-group-ids sg-09d256582b689c8f7 \
    --db-subnet-group-name dbcli1 \
    --backup-retention-period 1 \
    --no-publicly-accessible \
    --tags "Key=Name,Value=fromcli" 

# creare db instance in multi AZ for automatic replica
aws rds create-db-instance \
    --db-name demosqldb \
    --db-instance-identifier "demodb" \
    --allocated-storage 20 \
    --db-instance-class db.t2.micro \
    --engine mysql \
    --master-username root \
    --master-user-password rootroot \
    --vpc-security-group-ids sg-09d256582b689c8f7 \
    --multi-az \
    --db-subnet-group-name dbcli1 \
    --backup-retention-period 1 \
    --no-publicly-accessible \
    --tags "Key=Name,Value=fromcli" 

# Creation of create-db-instance-read-replica
aws rds create-db-instance-read-replica \
    --db-instance-identifier demodb-repl \
    --source-db-instance-identifier demodb \
    --db-instance-class db.t2.micro \
    --db-subnet-group-name dbcli1 \
    --vpc-security-group-ids sg-09d256582b689c8f7 

# promote read replica
aws rds promote-read-replica \
    --db-instance-identifier demodb-repl