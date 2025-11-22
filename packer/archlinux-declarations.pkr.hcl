##################################################################################
# VARIABLE DECLARATIONS
##################################################################################

variable "image_name" {
  type        = string
  default     = ""
  description = "Name of the Docker image"
}

variable "image_tag" {
  type        = string
  default     = ""
  description = "Tag for the Docker image"
}

variable "docker_registry" {
  type        = string
  default     = ""
  description = "Docker registry"
}

variable "maintainer" {
  type        = string
  default     = ""
  description = "Image maintainer"
}

