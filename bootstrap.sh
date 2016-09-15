sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible


#Setup terraform and teraform-inventory
[ -e terraform-inventory_v0.6.1_linux_amd64.zip ] && echo "Not downloading terraform-inventory_v0.6.1_linux_amd64.zip as it exists" ||  wget https://github.com/adammck/terraform-inventory/releases/download/v0.6.1/terraform-inventory_v0.6.1_linux_amd64.zip
[ -e terraform_0.7.3_linux_amd64.zip ] && echo "Not download terraform_0.7.3_linux_amd64.zip as it exists" || wget https://releases.hashicorp.com/terraform/0.7.3/terraform_0.7.3_linux_amd64.zip
[ -e terraform ] && echo "Not expanding terraform zip as it exists" || unzip terraform_0.7.3_linux_amd64.zip
[ -e terraform-inventory ] && echo "Not expanding terraform-inventory as it exists" || unzip terraform-inventory_v0.6.1_linux_amd64.zip
#[ -e terraform-ansible-aws-vpc-ha-wordpress ] && cd terraform-ansible-aws-vpc-ha-wordpress; git pull; cd .. || git clone https://github.com/arbabnazar/terraform-ansible-aws-vpc-ha-wordpress.git
if [[ $PATH =~ .*`pwd`.* ]] ; then echo "Path exists, not updating" ; else export PATH=$PATH:`pwd`; fi

#Setup ansbile dependencies
echo "Checking for required docker modules"
ansible-doc -l | grep -e docker_container -e docker_image -e docker_image_facts -e docker_login -e docker_service  
