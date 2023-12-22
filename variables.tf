variable "region" {
  type        = string
  description = "gcp region"
}

variable "env" {
  type        = string
  description = "environment"
}

variable "project" {
  type        = string
  description = "gcp project id"
}

variable "name" {
  type        = string
  description = "org name"
}

variable "subnet_01_configs" {
  description = "subnet 01 config"
  type = object({
    subnet_ip               = string
    secondary_subnet_ip_pod = string
    secondary_subnet_ip_svc = string
    subnet_private_access   = bool
  })
}

variable "subnet_02_configs" {
  description = "subnet 02 config"
  type = object({
    subnet_ip               = string
    secondary_subnet_ip_pod = string
    secondary_subnet_ip_svc = string
    subnet_private_access   = bool
  })
}