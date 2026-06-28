locals {
  common_tags = {
    project = var.project
    environment = var.environment
    terraform = "true"
    Name = local.common_name 
  }
  common_name = "${var.project}-${var.environment}"
  az_names = slice(data.aws_availability_zones.available.names, 0, 2)
}