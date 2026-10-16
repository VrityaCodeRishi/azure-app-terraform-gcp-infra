# GCP Capstone Infrastructure

Terraform infrastructure for the AgileEngine interview capstone. The current implementation creates a custom VPC, regional Google Kubernetes Engine (GKE) Standard cluster, private Cloud SQL for PostgreSQL instance, application Workload Identity, Artifact Registry, and keyless Azure DevOps deployment identity.

The detailed environment instructions are in [`infra/environments/dev/README.md`](infra/environments/dev/README.md).

## Repository layout

```text
infra/
├── environments/
│   └── dev/       # Deployer/root module, backend, provider, and dev values
└── modules/
    ├── vpc/       # Custom VPC, subnet, secondary ranges, router, and NAT
    ├── gke/       # GKE cluster, node pool, and node identity
    ├── cloudsql/                    # Private PostgreSQL instance and application database
    ├── cloudsql-workload-identity/  # Pod identity and Cloud SQL IAM user
    └── azure-devops-cicd/           # Artifact Registry and keyless pipeline identity
```
