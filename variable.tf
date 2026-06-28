variable "project" {
  type = string
}
variable "environment" {
  type = string
}
variable "cidr_vpc" {
  type = string
  default = "10.0.0.0/16"
}
variable "VPC_tags" {
  type = map(string)
  default = {}
}
variable "IGW_tags" {
  type = map(string)
  default = {}
}

variable "public_subnet_tags" {
  type = map(string)
  default = {}
}
variable "public_subnet_cidrs" {
  type = list
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "private_subnet_tags" {
  type = map(string)
  default = {}
}

variable "private_subnet_cidrs" {
  type = list
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "database_subnet_tags" {
  type = map(string)
  default = {}
}

variable "database_subnet_cidrs" {
  type = list
  default = ["10.0.21.0/24", "10.0.22.0/24"]
}
variable "public_route_table_tags" {
  type = map(string)
  default = {}
}
variable "private_route_table_tags" {
  type = map(string)
  default = {}
}
variable "database_route_table_tags" {
  type = map(string)
  default = {}
}
variable "public_route_table_association_tags" {
  type = map(string)
  default = {}
}
variable "private_route_table_association_tags" {
  type = map(string)
  default = {}
}
variable "database_route_table_association_tags" {
  type = map(string)
  default = {}
}
variable "nat_eip_tags" {
  type = map(string)
  default = {}
}
variable "nat_gateway_tags" {
  type = map(string)
  default = {}
}
variable "is_peering_required" {
  type = bool
  default = false
}
variable "peering_tags" {
  type = map(string)
  default = {}
}