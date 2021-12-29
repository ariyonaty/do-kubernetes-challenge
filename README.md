# do-kubernetes-challenge
Digital Ocean Kubernetes Challenge

Hey reader! This is all work in progress. Decided to learn kubernetes by jumping on the [DigitalOcean Kubernetes Challenge](https://www.digitalocean.com/community/pages/kubernetes-challenge). Learn by doing, eh?

I am a complete beginner to Kubernetes and this is all work in progress, so if you have any tips and tricks or best practices, I'd love to learn more and feel free to reach out. 

Cheers and happy holidays :)


## Terraform: Infrastructure Provisioning
Terraform will be used to automate the provisioning of the Kubernetes cluster and node pools.

### Usage:
Ensure `DIGITALOCEAN_TOKEN` variable is set:
`export DIGITALOCEAN_TOKEN=<DO_TOKEN>`

Validate Terraform configurion with:
`terraform plan -var "do_token=${DIGITALOCEAN_TOKEN}"`

Apply Terraform plan with:
`terraform apply -var "do_token=${DO_PAT}"`

The `terraform apply` command outputs the `cluster-id` of the deployed Kubernetes cluster upon completion. Make note of this id, as it will be used to fetch the kubeconfig.

Note: The cluster-id can be retrieved also by means of: `terraform output -raw cluster-id`
Note: This works! `terraform -chdir=terraform/ <REST OF CMD>` (I like running from project root)

### Helpers

A `fetch_config.sh` script has been created to help retrieve the kubeconfig of the deployed cluster. Again, ensure the `DIGITALOCEAN_TOKEN` variable has been properly set and run script like so:
`source ./fetch_config.sh <CLUSTER-ID>`

This will download the kubeconfig file which will be used with `kubectl`. Additionally, the environment variable `KUBECONFIG` will be set to the downloaded configuration, no longer having to manually include the `--kubeconfig` flag when running `kubectl`.

* `source helpers/fetch_config.sh $(terraform -chdir=terraform/ output -raw cluster-id)`

### Trow

Helm will be used to install [Trow](https://trow.io/), a container registry for kubernetes clusters.

* Adding the Trow helm repo
    `helm repo add trow https://trow.io`

* Install Trow with Helm
    `helm install trow trow/trow`

* Verify installation
    `kubectrl get services trow`

* Default appears to be listening on port 8000. Let's forward that to localhost for further confirmation.
    `kubectl port-forward trow-0 8000:8000`

* Visiting http://localhost:8000, we are greeted with "Welcome to Trow, the cluster registry"

<br>
Appears to be an issue here with containerd/docker. For now, manual installation of trow:

1) Modify trow.yaml in trow/quick-install/ such that {{namespace}} -> 'kube-public'
2) Run: `kubectl apply -f trow.yaml`
3) Wait a bit. Then run: `kubectl certificate approve trow.kube-public`
4) Run: `./copy-certs.sh`
5) Run: `./configure-host.sh --add-hosts`

<br>
Scratch that.. just modified install.sh script and removed docker/containerd check. Might just work..

<br> Scratch that pt 2... install.sh scripts works out-of-box when not dealing working with Kubernetes version >= 1.20.X


### Deployments

#### Pushing Docker Images

* Tagging images:
`docker tag flask_demo:0.0.1 trow.kube-public:31000/flask_demo:0.0.1`

* Pushing images:
`docker push trow.kube-public:31000/flask_demo:0.0.1`


### Oddities

1) Running the helm install trow appears to create a volume in DO. Terraform doesn't track this and destroying the resources does not include this volume.
2) Trow doesn't like containerd, which is the container runtime starting with DOKS version 1.20. Therefore, gotta jump back to an older version :(. See this [issue](https://github.com/ContainerSolutions/trow/issues/78) and the DOKS changelog [here](https://docs.digitalocean.com/products/kubernetes/changelog/)


### Resources
- https://blog.wimwauters.com/devops/2021-02-15-digitalocean_terraform_k83/

---

## Current Working Procedure 

```
terraform -chdir=terraform/ apply -var "do_token=${DO_PAT}"
source helpers/fetch_config.sh $(terraform -chdir=terraform/ output -raw cluster-id)
cd trow/quick-install/
./install.sh
docker push trow.kube-public:31000/flask_demo:0.0.1
kubectl create -f deployment.yaml
```

Get IP from `kubectl get service` and navigate to http://<IP>:8080. Refreshing a couple of times will show the loadbalancing in effect.



