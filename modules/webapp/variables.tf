variable "name" {
  type        = string
  description = "Web App name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
}

variable "app_service_plan_name" {
  type        = string
}

variable "container_image" {
  type        = string
  description = "Container image name (e.g. nginx:latest)"
  default     = "nginx:alpine"
}

variable "node_version" {}

variable "container_registry_url" {
  type        = string
  description = "Container registry URL (e.g. https://index.docker.io)"
  default     = "https://index.docker.io"
}

variable "tags" {
  type    = map(string)
  default = {}
}
