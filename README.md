# server-phoenix

Project Purpose: To refamiliarise my self with ansible (and begin learning terraform).

I understand this will be "reinventing the wheel" somewhat, but it is a learning exercise.

This project will create and provision cloud resources to run a number of services.

Terraform will create GCP compute instance with networking and persistent disk.

Ansible will provision the instance as follows

To start off - this will run a single node docker swarm.
On the swarm ansible will deploy the following:

    * Portainer

    * Traefik

    * Jenkins


Traefik will use LetsEncrypt, combined with nip.io for free domains and TLS.

## Steps

### Assumptions
User has installed Ansible (2.9), Terraform(0.12.x), gcloud SDK and logged in via gcloud.


1. Open `gcloud_init_vars` and change as appropriate for desired naming convention. 

2. Run `gcloud_init.sh` 
    This will create a terraform variables file to be used, and the SA key.json for Terraform google provider.

3. `cd` into `terraform` and run:
    
    ```
    terraform init
    terraform plan
    terraform apply
    ```

4. After Terraform has finished, ensure you can ssh to the GCP instance via the output IP address.

5. Alter the Ansible playbook vars to include the IP address in the `nip.io` URLs

6. `cd` into `ansible` and run the playbook:

    ```
    ansible-playbook -u gordon -i inventory/inventory playbooks/gcpserver.yaml --private-key ~/.ssh/gcp_id
    ```

7. Go to the jenkins URL and follow setup steps

8. If required, open desired ports for portainer/traefik to view dashboards.


## Known Issues

### GCP & Terraform

Google provider for terraform requires a key.json file to authenticate, which is provided on Service Account (SA) Creation.
Service Accounts appear to be heavily coupled to Google Projects. Meaning a GCP Project and SA must be created prior to using terraform.

I have not found a better way to do this yet - opinions welcome!
For now, I have `gcloud_init.sh` to carry out pre-requsite steps for Terraform.

### Ansible docker_stack with ubuntu 20.04

Running the ansible scripts on and ubuntu 20.04 image fails at deploying portainer stack. 
Have not looked into this properly - but the error states docker_stack cannot find the portainer stack file.

The same playbook task runs on ubuntu 18.04 images. The only other difference is how docker is installed (apt on 18.04, snap on 20.04)
