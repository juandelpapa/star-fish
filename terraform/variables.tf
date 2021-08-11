# All vars require updating for specific VPC resource values
variable "vpc" {
    default = "vpc-013b170fd4ddf46c7"
}

variable "public" {
    default = "subnet-04fc46154fe4891ad"
}

variable "private" {
    default = "subnet-0025826927be53eda"
}