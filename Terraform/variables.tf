variable "aws_region" {
  default = "eu-central-1"
}

variable "cluster-name" {
  default = "eks-epam"
  type    = string
}

variable "ecr_name" {
  default = "starwars"
  type    = string
}

variable "rds_db_pass" {
  description = "RDS db password"
  type = string
  sensitive = true
}

variable "rds_db_user" {
  description = "RDS db user"
  type = string
  sensitive = true
}

variable "rds_db_name" {
  description = "RDS db user"
  type = string
  sensitive = true
}

