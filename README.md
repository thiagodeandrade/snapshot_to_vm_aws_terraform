# Script to create a EC2 instance from snapshot with terraform

This script get last snapshot from a EC2 instance and create new virtual machine

This script create a dns entrance, A, in determinated zone in Route53

# Pre-requists

You will need last ID Snapshot and ID Zone in you Route53

```
variable "client" {
    type = "string"
    default = "clientburguer"
}

variable "mydnszone" {
    type = "string"
    default = "ZXXXXXX"
}
```

