# do-kubernetes-challenge
Digital Ocean Kubernetes Challenge

Hey reader! This is all work in progress. Decided to learn kubernetes by jumping on the [DigitalOcean Kubernetes Challenge](https://www.digitalocean.com/community/pages/kubernetes-challenge). Learn by doing, eh?

I am a complete beginner to Kubernetes and this is all work in progress, so if you have any tips and tricks or best practices, I'd love to learn more and feel free to reach out. 

Cheers and happy holidays :)


# Terraform: Infrastructure Provisioning
Terraform will be used to automate the provisioning of the Kubernetes cluster and node pools.

## Usage:
Ensure `DIGITALOCEAN_TOKEN` variable is set:
`export DIGITALOCEAN_TOKEN=<DO_TOKEN>`

Validate Terraform configurion with:
`terraform plan -var "do_token=${DIGITALOCEAN_TOKEN}"`

Apply Terraform plan with:
`terraform apply -var "do_token=${DO_PAT}"`

The `terraform apply` command outputs the `cluster-id` of the deployed Kubernetes cluster upon completion. Make note of this id, as it will be used to fetch the kubeconfig.

## Helpers

A `fetch_config.sh` script has been created to help retrieve the kubeconfig of the deployed cluster. Again, ensure the `DIGITALOCEAN_TOKEN` variable has been properly set and run script like so:
`./fetch_config.sh <CLUSTER-ID>`

This will download the kubeconfig file which will be used with `kubectl`.
