###cloud vars

variable "cloud_id" {
  type        = string
  default     = "b1gkboa1n6dd8g2tkcoj"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default     = "b1g13lskl3fnr1fml9pu"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "vpc_name" {
  type        = string
  default     = "netovpc"
  description = "VPC network name"
}

variable "neto_nat_ip" {
  type        = string
  default     = "192.168.10.254"
  description = "Neto net ip"
}

variable "neto_sub_pub_name" {
  type        = string
  default     = "public"
  description = "Public subnet name"
}

variable "neto_sub_priv_name" {
  type        = string
  default     = "private"
  description = "Private subnet name"
}

variable "neto_pub_cidr" {
  type        = list(string)
  default     = ["192.168.10.0/24"]
  description = "Public subnet cidr"
}

variable "neto_priv_cidr" {
  type        = list(string)
  default     = ["192.168.20.0/24"]
  description = "Private subnet cidr"
}

variable "vm_image_id" {
  type        = string
  default     = "fd80mrhj8fl2oe87o4e1"
  description = "VM custom image ID"
}

variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
    bdisksize      = number
    bdisktype     = string
    platid        = string
  }))
  default = {
    nnat = {
      cores         = 2
      memory        = 2
      core_fraction = 5
      bdisksize     = 10
      bdisktype     = "network-hdd"
      platid        = "standard-v2"
    }
    npub = {
      cores         = 2
      memory        = 4
      core_fraction = 5
      bdisksize     = 10
      bdisktype     = "network-hdd"
      platid        = "standard-v2"
    }
    npriv = {
      cores         = 2
      memory        = 4
      core_fraction = 5
      bdisksize     = 10
      bdisktype     = "network-hdd"
      platid        = "standard-v2"
    }
  }
}
variable "vms_metadata" {
  type = map(object({
    sport           = number
    skeys           = string
  }))
  default = {
    metassh= {
      sport         = 1
      skeys         = "zhelanov:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEoPKcv9/oVqeP2irzonN4rB1GCChuDsTaledNpkcEpe root@Uglycomp"
    }
  }
}
