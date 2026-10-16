# GKE module

Creates a regional GKE Standard cluster and separately managed primary node pool with:

- Private worker nodes
- DNS-only control-plane access
- VPC-native Pod and Service ranges supplied by the caller
- Workload Identity Federation for GKE
- Gateway API and Dataplane V2
- Shielded nodes
- Dedicated node service account
- Release channel, maintenance window, auto-repair, and auto-upgrade
- Cloud Logging, Cloud Monitoring, and managed Prometheus

The module expects an existing network and subnetwork. It does not configure a provider or backend; those responsibilities remain with the calling root module.
