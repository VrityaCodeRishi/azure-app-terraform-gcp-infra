# VPC module

Creates a custom-mode regional VPC foundation for a VPC-native GKE cluster:

- Node subnet
- Separate Pod and Service secondary ranges
- Private Google Access
- A dedicated global address range for Private Services Access
- A Service Networking connection for private Google-managed services such as Cloud SQL
- Cloud Router
- Cloud NAT for all primary and secondary ranges in every regional subnet, with errors-only logging

The module does not configure a provider or backend. The calling root module supplies the inherited `google` provider and passes project/environment-specific values as inputs.
