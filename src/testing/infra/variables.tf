variable "location" {
  description = "The Azure Region in which the master and the shared storage account will be provisioned."
  type        = string
  default     = "northeurope"
}

variable "environment" {
  description = "Environment Resource Tag"
  type        = string
  default     = "dev"
}

variable "locust_version" {
  description = "Locust Container Image Version"
  type        = string
  default     = "locustio/locust:1.3.0"
}

variable "targeturl" {
  description = "Target URL"
  type        = string
  default     = "https://my-sample-app.net"
}

variable "locustWorkerNodes" {
  description = "Number of Locust worker instances (zero will stop master)"
  type        = string
  default     = "0"
}

variable "locust_worker_locations" {
  description = "List of regions to deploy workers to in round robin fashion"
  type        = list
  default     = ["northeurope", "eastus2", "westeurope", "westus", "australiaeast", "francecentral", "southcentralus", "japaneast", "southindia", "brazilsouth", "germanywestcentral", "uksouth", "canadacentral", "eastus2", "uaenorth"]
}

variable "prefix" {
  description = "A prefix used for all resources in this example. Must not contain any special characters. Must not be longer than 10 characters."
  type        = string
  validation {
    condition     = length(var.prefix) >= 5 && length(var.prefix) <= 10
    error_message = "Prefix must be between 5 and 10 characters long."
  }
}
