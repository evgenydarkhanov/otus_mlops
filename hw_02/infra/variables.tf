### PROVIDER VARIBLES AND SHARED VARIABLES ###
variable "yc_zone" {
  description = "The availability zone to use for resources"
  type        = string
}

variable "yc_token" {
  description = "The OAuth token for Yandex Cloud"
  type        = string
}

variable "yc_cloud_id" {
  description = "The ID of the Yandex Cloud"
  type        = string
}

variable "yc_folder_id" {
  description = "The ID of the Yandex Cloud folder"
  type        = string
}

variable "public_key_path" {
  description = "Path to the public key file"
  type        = string
}

variable "private_key_path" {
  description = "Path to the private key file"
  type        = string
}

### IAM VARIABLES ###
variable "yc_service_account_name" {
  description = "The name of the service account to create"
  type        = string
}

### NETWORK VARIABLES ###
variable "yc_network_name" {
  description = "Name of the network"
  type        = string
}

variable "yc_subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "yc_subnet_range" {
  description = "IDR block for the subnet"
  type        = string
}

variable "yc_nat_gateway_name" {
  description = "Name of the NAT gateway"
  type        = string
}

variable "yc_route_table_name" {
  description = "Name of the route table"
  type        = string
}

variable "yc_security_group_name" {
  description = "Name of the security group"
  type        = string
}

### STORAGE VARIABLES ###
variable "yc_bucket_name" {
  description = "The name of the storage bucket to create"
  type        = string
}

variable "yc_bucket_size" {
  description = "The size of the storage bucket to create"
  type        = number
}

variable "yc_default_storage_class" {
  description = "The class of the storage bucket to create"
  type        = string
}

### DATA PROC VARIABLES ###
variable "yc_dataproc_cluster_name" {
  description = "Name of the Data Proc cluster"
  type        = string
}

variable "yc_dataproc_version" {
  description = "Version of Dataproc"
  type        = string
}

variable "dataproc_master_resources" {
  type = object({
    resource_preset_id = string
    disk_type_id       = string
    disk_size          = number
  })
  default = {
    resource_preset_id = "s3-c2-m8"
    disk_type_id       = "network-ssd"
    disk_size          = 40
  }
}

variable "dataproc_data_resources" {
  type = object({
    resource_preset_id = string
    disk_type_id       = string
    disk_size          = number
  })
  default = {
    resource_preset_id = "s3-c4-m16"
    disk_type_id       = "network-ssd"
    disk_size          = 128
  }
}

### PROXY VIRTUAL MACHINE VARIABLES ###
variable "yc_image_id" {
  description = "ID of the image for the virtual machine"
  type        = string
}

variable "yc_instance_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "yc_platform_id" {
  description = "The platform ID for the VM"
  type        = string
}

variable "yc_instance_cores" {
  description = "The number of CPU cores for the VM"
  type        = number
}

variable "yc_instance_memory" {
  description = "The amount of memory (GB) for the VM"
  type        = number
}
