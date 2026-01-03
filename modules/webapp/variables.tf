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

variable "webapp_subnet_id" {
  type        = string
  description = "The ID of the subnet to deploy the web app into"
}

variable "app_service_plan_name" {
  type        = string
}

variable "container_image" {
  type        = string
  description = "Container image name (e.g. nginx:latest)"
  default     = "nginx:alpine"
}

variable "node_version" {
  description = "Node.js version for App Service"
  type        = string
  default     = "18-lts"
}

variable "container_registry_url" {
  type        = string
  description = "Container registry URL (e.g. https://index.docker.io)"
  default     = "https://index.docker.io"
}

variable "tags" {
  type    = map(string)
  default = {}
}
