terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.3"
    }
  }
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
variable "password" {
  sensitive = true
}
variable "sshkeys" {}

resource "proxmox_vm_qemu" "vm" {
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
