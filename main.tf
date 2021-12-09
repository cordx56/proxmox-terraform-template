terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.3"
    }
  }
}

variable "pm_api_token_id" {}
variable "pm_api_token_secret" {}
variable "pm_api_url" {}

provider "proxmox" {
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_api_url          = var.pm_api_url
}

variable "name" {
  default = "ubuntu-server"
}
variable "target_node" {}
variable "clone" {
  default = "ubuntu-server-focal"
}
variable "cores" {
  default = 4
}
variable "memory" {
  default = 2048
}
variable "ipaddress" {
  default = "dhcp"
}
variable "gateway" {
  default = "192.168.1.1"
}
variable "nameserver" {
  default = ""
}
variable "storage" {
  default = "local-btrfs"
}
variable "storage_size" {
  default = "20G"
}

variable "user" {}
variable "password" {}
variable "sshkeys" {}

resource "proxmox_vm_qemu" "ubuntu-server" {
  name        = var.name
  target_node = var.target_node

  clone = var.clone

  cores   = var.cores
  memory  = var.memory
  os_type = "cloud-init"

  scsihw = "virtio-scsi-pci"
  disk {
    type    = "scsi"
    storage = var.storage
    size    = var.storage_size
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
  ipconfig0  = var.ipaddress == "dhcp" ? "dhcp" : "ip=${var.ipaddress},gw=${var.gateway}"
  nameserver = var.nameserver

  ciuser     = var.user
  cipassword = var.password
  sshkeys    = var.sshkeys
}
