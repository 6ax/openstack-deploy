terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.6.8"
    }
  }
  required_version = ">= 0.13"
}

# https://github.com/Telmate/terraform-provider-proxmox
provider "proxmox" {
    pm_api_url = var.pm_api_url
    pm_user = var.pm_user
    pm_password = var.pm_password
    # pm_tls_insecure = "true"
}

/* Null resource that generates a cloud-config file per vm */
data "template_file" "user_data" {
  for_each = var.nodes
  template = file("${path.module}/cloud-init-configs/coud-init-template.yml")
  vars = {
    pubkey   = var.cloud_init_ssh_public_key
    hostname = each.value.name
    fqdn     = "${each.value.name}.${var.domain_name}"
  }

}
resource "local_file" "cloud_init_user_data_file" {
  for_each = var.nodes
  content  = data.template_file.user_data[each.key].rendered
  filename = "${path.module}/cloud-init-configs/user_data_${each.value.name}.cfg"
}

resource "null_resource" "cloud_init_config_files" {
  for_each = var.nodes
  connection {
    type     = "ssh"
    user     = var.pve_user
    password = var.pve_password
    host     = "${each.value.target_node}.${var.domain_name}"
  }

  provisioner "file" {
    source      = local_file.cloud_init_user_data_file[each.key].filename
    destination = "/var/lib/vz/snippets/user_data_vm-${each.value.name}.yml"
    #destination = "/mnt/pve/storage-01/snippets/user_data_vm-${each.value.name}.yml"
  }
}


# /* Configure cloud-init User-Data with custom config file */
resource "proxmox_vm_qemu" "cloudinit-test" {
  for_each = var.nodes
  depends_on = [
    null_resource.cloud_init_config_files,
  ]
  name = each.value.name
  desc = each.value.description
  target_node = each.value.target_node

  clone = "ci-ubuntu-template"
  full_clone = true

  cores = "8"
  sockets = "1"
  memory = "16384"
  # numa = "true"
  # balloon = "1"
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"
  agent = "1"

disk {
    type = "scsi"
    storage = "ceph-storage"
    size = "60G"
    format = "raw"
   }
    
  network {
    model = "virtio"
    bridge = "vmbr0"
    tag = "4"
  }

  os_type = "cloud-init"
  ipconfig0 = "ip=${each.value.ip}/${each.value.netmask},gw=${each.value.gw}"
  #cicustom = "user=storage-01:snippets/user_data_vm-${each.value.name}.yml"
  cicustom = "user=local:snippets/user_data_vm-${each.value.name}.yml"
}
