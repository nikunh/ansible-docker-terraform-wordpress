# ansible-docker-terraform-wordpress
A turnkey project to use ansible, terraform, docker and custom scripts to bring up functioning wordpress blog

##What it does:##
  1. It creates 'n' number of instances. Where the value for count of instances is provided during setup.
  2. It creates these instances in EC2, and corresponding security groups and elb's.
  3. Setups docker on these instances.
  4. Starts mariadb mysql and wordpress linked docker containers on these instances.
  5. Does port maping to make the wordpress reachable on port 8080 on local machine.
  6. Adds the instances to elb.
  7. Currently it only creates public instances and elb's, but this can be easily modified to create private only instances.

##This project assumes the following:##
  1. You already have a aws account with vpc and subnets created where you will deploy these instances.
  2. You have basic working knowledge of ansbile and terraform.

##Requirements:##
  1. Currently the scripts and playbooks have been tested only for ubuntu 14 trusty. No guarantee on how or if it will perform on other platforms.
  2. You will need to make sure to follow the instructions properly to make sure the scripts have all required data before executing the setup scripts.

##Setup Instructions:##
  There are two shell scripts for use. 

 **Bootstrap.sh:** (Tested and aproved for Ubuntu 14.04.1 LTS) 
      
      This script can be used by developer to setup the initial environment required by this project. It installs and creates environments for ansbile, terraform, terraform-inventory and related dependencies. This should be the first script to be run by user. If you already have a working ansbile and terraform setup on your local machine, you can skip this.

 **Cloud-automation.sh:** (Tested and aproved for Ubuntu 14.04.1 LTS, but should work without problems on any other unix like OS)
      
      This script is the main script to be used for provisioning. It has few dependencies, that need to be created first.
      
          1. Create a terraform.tfvars file in terraform_infra/aws with following values:
              aws_region = "<AWS Region>"
              key_path = "<path to your ssh private key # will be used to connect to host>" 
              key_name = "<aws key pair name to be used for provisioning instances>"
              subnet_id = "<subnet id where the resources will be created>"
              vpc_id = "<vpc id where the resources will be created>" 
          2. Run the script in following syntax:
              Example: '. cloud-automation.sh -a wpapp2 -e dev -c 2 -s "t2.micro"'
              *Note the . and splace before the script name.*
                  -a : Application name, used to identify created resources
                  -e : Environemnt name, used to classify created resources
                  -c : Count of instances to be created, default 2
                  -s : Server size, remember to use correct name from aws instance types. The brackets are required because it has a '.' in its name.
          3. Running this script will prompt you for 
              a. AWS Key to be used for connecting to AWS
              b. AWS secret to be used for connecting to AWS
              c. Username: This string will be used to prefix created resource names, for better identification.

After that it will show you a list of variables and their respective variables that it will use for next steps and wait for confirmation. After confirmation, it will proceed to provision the infrastructure, configure it and by the end you should have a working blog setup.
