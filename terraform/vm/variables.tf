variable "subscription_id" {
  description = "Subscription ID for Azure account"
}

variable "client_id" {
  description = "Client ID for Azure account"
}

variable "client_secret" {
  description = "Client secret for Azure account"
}

variable "tenant_id" {
  description = "Tennant ID for Azure account"
}

variable "image_uri" {
  description = "Resource ID for the virtual machine image"
  default     = "/subscriptions/c0a607b2-6372-4ef3-abdb-dbe52a7b56ba/resourceGroups/nicgeneral/providers/Microsoft.Compute/snapshots/quake-server"
}

variable "location" {
  default = "West US 2"
}

variable "arm_access_key" {

}
