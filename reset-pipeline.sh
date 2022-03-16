#!/bin/bash


fly -t ps destroy-pipeline  -p terraform-fmt-validate 

fly -t ps set-pipeline -c pipeline_terraform.yml -p terraform-fmt-validate
fly -t ps unpause-pipeline -p terraform-fmt-validate