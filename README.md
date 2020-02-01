#1 contains a GCP VPC network with 5 subnets and also 1 of the subnet include multiple subnet ranges. This enables to just modify on tfvars
#2. Firewall rules includes 4 rules:
  A. Egress
  B. Ingress
  C. Service Account both at Source and Targets
  D. Source and Target "Tags"
It's missing the Service account other scenarios.
