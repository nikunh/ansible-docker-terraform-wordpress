#!/bin/sh 

# Parse all arguments
num_servers=2
server_size="t2.micro"

usage() { echo "cloud-automation.sh -a <app name> -e <environment> -c <num_servers> -s <server_size>" 1>&2; read -p "Press any key to exit " answer; exit 1; }

shift $((OPTIND-1))
while getopts "a:e:c:s:" o; do
    case "$o" in
        a)
            app_name=$OPTARG
            ;;
        e)
            env_name=$OPTARG
            ;;
	c)
            num_servers=$OPTARG
            ;;
	s)
            server_size=$OPTARG
            ;;
        *)
            usage
            ;;
    esac
done
echo $app_name $env_name $num_servers $server_size
if [ -z "${app_name}" ] || [ -z "${env_name}" ]; then
    usage
fi

shift $((OPTIND-1))
#Read AWS access key information for use with terraform
read -p "AWS_ACCESS_KEY_ID: " AWS_ACCESS_KEY_ID
stty -echo 
read -p "AWS_SECRET_ACCESS_KEY: " AWS_SECRET_ACCESS_KEY; echo 
stty echo
export TF_VAR_AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export TF_VAR_AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

#Read other required variables and export them
read -p "User name (without space): " USER_NAME 
export TF_VAR_USER_NAME=$USER_NAME
export TF_VAR_NUM_SERVERS=$num_servers
export TF_VAR_SERVER_SIZE=$server_size
export TF_VAR_ENV_NAME=$env_name
export TF_VAR_APP_NAME=$app_name
env | grep TF_VAR
if [[ $PATH =~ .*`pwd`.* ]] ; then echo "Path exists, not updating" ; else export PATH=$PATH:`pwd`; fi
read -p "Ready to create resources? " createconfirmation
cd terraform_infra/aws
terraform apply .
cd ../..

# Now lets setup docker and the wordpress on your created nodes
prisshkey=`cat terraform_infra/aws/terraform.tfvars | grep key_path | awk -F' = ' '{print $2}'|sed -e 's/\"//g'`
export TF_STATE="terraform_infra/aws/terraform.tfstate"
terraforminventorypath=`pwd`/terraform-inventory
ansible-playbook --inventory-file=$terraforminventorypath --private-key=$prisshkey playbooks/deploy.yml 
