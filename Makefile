.PHONY: help all-up infra-up ansible-up all-down infra-validate infra-plan bootstrap ssh-gen infra-init pack

help:
	@echo "Specify a target\n"

all-up:
	make infra-up
	make ansible-up
	make ansible-get-ips
	make pack
	make ansible-playbook

all-up-fresh:
	make ssh-gen
	make infra-init
	make infra-plan
	make infra-up
	make ansible-get-ips
	make pack
	make ansible-playbook


infra-up:
	cd infra && terraform apply --auto-approve
	cd infra && terraform output

ansible-up:
	cd ansible/scripts && ./run-ansible.sh

infra-down:
	cd infra && terraform destroy --auto-approve 

#

infra-validate:
	cd infra && terraform validate && terraform fmt

infra-plan:
	cd infra && terraform plan

infra-apply:
	cd infra && terraform apply

bootstrap:
	cd bootstrap && terraform init && terraform apply --auto-approve

ssh-gen:
	mkdir -p /tmp/keys
	yes | ssh-keygen -t rsa -b 4096 -f /tmp/keys/ec2-key -P ''
	chmod 0644 /tmp/keys/ec2-key.pub
	chmod 0600 /tmp/keys/ec2-key

infra-init:
	cd infra && terraform init



ansible-get-ips:
	cd ansible && echo -n "web:\n hosts:\t"  > inventory.yml
	cd infra && terraform output instance_web >> ../ansible/inventory.yml
	cd ansible && echo -n "db:\n hosts:\t"  >> inventory.yml
	cd infra && terraform output instance_db >> ../ansible/inventory.yml
	cd src && echo -n "SERVER=mongodb://"  > .env
	cd infra && terraform output instance_db | tr -d '"'| tr -d '\n' >> ../src/.env
	cd src && echo -n ":27017"  >> .env

ansible-playbook:
	cd ansible && ansible-playbook --private-key=/tmp/keys/ec2-key -i inventory.yml -u ec2-user playbook.yml

infra-get-web-output:

	cd infra && terraform output instance_web


pack:
	cd src && npm pack
	if [ -d "ansible/files/" ];	\
	then mv src/notes-1.0.0.tgz ansible/files/notes-1.0.0.tgz;\
	else \
	mkdir ansible/files/ && \
	mv src/notes-1.0.0.tgz ansible/files/notes-1.0.0.tgz; \
	fi
