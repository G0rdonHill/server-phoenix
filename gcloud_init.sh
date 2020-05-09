#!/bin/bash

# Pre-requisite steps for terraform on GCP
## GCP provider states best practive is to use a service account
## Service accounts need to be tied to a project on creation

source $(dirname $0)/gcloud_init_vars

pre_check(){
#Check gcloud is installed
    status=$(gcloud --version > /dev/null)
    if [[ $status -ne 0 ]]; then
        echo -e "\nERROR: gcloud sdk is not installed. Please install here: https://cloud.google.com/sdk/install"
        exit 1
    fi
}
create_project(){
    # Create new project
    exists=$(gcloud projects list | grep $project_name)
    if [[ $exists ]]; then
        echo -e "\nWARN: Project $project_name already exists! Skipping.."
    else
        status = $(gcloud projects create --name $project_name --set-as-default)
        if [[ $status -ne 0 ]]; then
            echo -e "\nERROR: Could not create GCP project $project_name"
            exit 1
        fi
    fi
    export project_id=$(gcloud projects list | grep $project_name | awk '{print $1}')
}

create_sa(){
    # Create Service account
    exists=$(gcloud iam service-accounts list | grep $sa_name)
    if [[ $exists ]]; then
        echo -e "\nWARN: Service Account $sa_name in $project_name already exists! Skipping.."
    else
        status=$(gcloud iam service-accounts create $sa_name \
            --description="$sa_desc" \
            --display-name="$sa_disp_name")
        if [[ $status -ne 0 ]]; then
            echo -e "\nERROR: Could not create GCP Service Account: $sa_name"
            exit 1
        fi
    fi
    
    sa_email=$(gcloud iam service-accounts list | grep $sa_name | awk '{print $2}')

    # Grant SA Editor Role
    gcloud projects add-iam-policy-binding $project_id \
        --member serviceAccount:$sa_email \
        --role roles/editor

    # Download SA key json
    status=$(gcloud iam service-accounts keys create $out_file \
        --iam-account="$sa_email" \
        --key-file-type="json")
    if [[ $status -ne 0 ]]; then
        echo -e "\nERROR: Could not download Service Account Key"
        exit 1
    fi
    # Fix this later
    mv $out_file ./terraform/
}

populate_vars(){
    # Populate Terraform variables.
    ## There will be a better way to do this, quick and dirty for now.
    #get project ID
    project_id=$(gcloud projects list | grep $project_name | awk '{print $1}')
    sed -e "s/__PROJECT__/$project_id/g" \
        -e "s~__CREDS__~$out_file~g" \
        $(dirname $0)/terraform/variables.tmpl > $(dirname $0)/terraform/variables.tf
}

enable_apis(){
    #Some APIs are not enabled by default when creating a new project
    enabled=$(gcloud services list | grep compute.googleapis.com )
    if [[ $enabled ]]; then
        echo -e "\nINFO: GCP Compute API already enabled on project $project_name. Skipping.."
    else
        status=$(gcloud services enable compute.googleapis.com)
        if [ $status -ne 0 ]; then
            echo -e "\nERROR:  Could not enable GCP Compute API"
            exit 1
        fi
    fi
}

pre_check
create_project
create_sa
populate_vars
enable_apis