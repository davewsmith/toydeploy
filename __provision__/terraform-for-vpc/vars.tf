variable "project-name" {
  description = "Name of this project"
  default     = "toydeploy"
}

variable "key-name" {
  description = "Key Pair name"
  default     = "toydeploy"
}

variable "cidr_vpc" {
  description = "CIDR block for VPC"
  default     = "10.1.0.0/16"
}

variable "cidr_subnet" {
  description = "CIDR block for subnet"
  default     = "10.1.0.0/20"
}
