# Dev VPC, GKE, and Cloud SQL environment

This directory is the deployer/root module for the `dev` environment. It configures the Google provider and GCS backend, enables project APIs, and composes reusable child modules from `../../modules`.

```text
environments/dev
├── module.vpc ──────> ../../modules/vpc
├── module.gke ──────> ../../modules/gke
└── module.cloudsql ─> ../../modules/cloudsql
                          ▲
                          └── VPC outputs are passed to GKE and Cloud SQL
```

The deployment creates:

- Required Compute, GKE, Cloud SQL, Service Networking, IAM, Logging, and Monitoring APIs
- Custom-mode regional VPC
- GKE node subnet with separate Pod and Service secondary ranges
- Private Google Access
- Cloud Router and Cloud NAT with error logging
- A dedicated Private Services Access range and Service Networking connection
- Regional GKE Standard cluster
- Private worker nodes
- DNS-only Kubernetes control-plane endpoint
- Workload Identity Federation for GKE
- Dataplane V2 network policy enforcement
- Gateway API controller
- Shielded nodes and a dedicated node service account
- Auto-repair, auto-upgrade, managed Prometheus, and a maintenance window
- A cost-controlled node pool that scales between one and three total nodes
- A private PostgreSQL 16 Cloud SQL instance with no public IP
- SSD automatic storage growth, automated backups, PITR, Query Insights, and an initial `app` database

Environment-specific values stay here. Resource implementation details stay in the child modules.

## Prerequisites

- A Google Cloud project with billing enabled
- Permission to enable APIs, create networking/GKE resources, service accounts, and project IAM bindings
- Terraform 1.10 or newer
- Google Cloud CLI, `kubectl`, and the `gke-gcloud-auth-plugin`
- A GCS bucket for Terraform state

Authenticate for local Terraform use:

```bash
gcloud auth application-default login
gcloud config set project YOUR_PROJECT_ID
```

## Configure the remote state

The GCS backend intentionally has no bucket hard-coded in version control. After creating the bucket, copy the example and replace its placeholder:

```bash
cd infra/environments/dev
cp backend.hcl.example backend.hcl
```

Recommended state-bucket controls are object versioning, uniform bucket-level access, public access prevention, and narrowly scoped IAM. The bucket must exist before initialization.

Initialize or migrate this environment:

```bash
terraform init -backend-config=backend.hcl
```

If this root was previously initialized with local state, use:

```bash
terraform init -migrate-state -backend-config=backend.hcl
```

The GCS backend supports state locking. Do not commit `backend.hcl`, `.terraform/`, plan files, or state files.

## Configure and deploy

Create local input values:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Replace `project_id`, review the region and labels, then run:

```bash
terraform fmt -check -recursive
terraform validate
terraform plan -out=infra.tfplan
terraform apply infra.tfplan
```

Provisioning a regional GKE cluster and Cloud SQL instance can take several minutes and creates billable resources.

## Connect through the DNS endpoint

After apply, run the command printed by the `get_credentials_command` output. It has this form:

```bash
gcloud container clusters get-credentials CLUSTER_NAME \
  --region REGION \
  --project PROJECT_ID \
  --dns-endpoint

kubectl get nodes
```

The caller needs an IAM role containing `container.clusters.connect`, such as Kubernetes Engine Developer or Viewer, plus appropriate Kubernetes RBAC for the requested actions. The DNS endpoint uses IAM authentication; legacy Kubernetes tokens and client certificates are not enabled.

## Cost and availability note

The cluster control plane is regional, but the dev node pool is allowed to run only one total node to reduce cost. The development Cloud SQL instance is zonal and therefore does not automatically fail over during a zonal outage. Increase the node minimum and change `cloudsql_availability_type` to `REGIONAL` for production availability. Cloud NAT, Cloud SQL, backups, and detailed GKE observability incur charges.

## Destroy

For the disposable dev environment, `deletion_protection` defaults to `false`:

```bash
terraform plan -destroy -out=destroy.tfplan
terraform apply destroy.tfplan
```

If GKE or Cloud SQL deletion protection was enabled, set `deletion_protection` or `cloudsql_deletion_protection` to `false` and apply that change before planning destruction. The external GCS state bucket is not managed by this root and is not deleted.
