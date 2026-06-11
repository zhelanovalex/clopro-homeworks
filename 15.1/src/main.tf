resource "yandex_vpc_network" "net_vpc" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "net_vpcsub_pub" {
  name           = var.neto_sub_pub_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.net_vpc.id
  v4_cidr_blocks = var.neto_pub_cidr
}

resource "yandex_vpc_subnet" "net_vpcsub_priv" {
  name           = var.neto_sub_priv_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.net_vpc.id
  v4_cidr_blocks = var.neto_priv_cidr
  route_table_id = yandex_vpc_route_table.neto_priv_route.id
}

resource "yandex_vpc_route_table" "neto_priv_route" {
  network_id = yandex_vpc_network.net_vpc.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = var.neto_nat_ip
  }
}

resource "yandex_compute_instance" "nat" {
  count       = 1
  name        = "neto-nat-0${count.index + 1}"
  hostname    = "neto-nat-0${count.index + 1}"
  platform_id = var.vms_resources["nnat"].platid
  resources {
    cores         = var.vms_resources["nnat"].cores
    memory        = var.vms_resources["nnat"].memory
    core_fraction = var.vms_resources["nnat"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = var.vm_image_id
      size     = var.vms_resources["nnat"].bdisksize
      type     = var.vms_resources["nnat"].bdisktype
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.net_vpcsub_pub.id
    nat       = true
    ip_address = var.neto_nat_ip
  }
  metadata = {
    serial-port-enable = var.vms_metadata["metassh"].sport
    ssh-keys           = var.vms_metadata["metassh"].skeys
  }
}

resource "yandex_compute_instance" "platform_netopub" {
  count       = 1
  name        = "neto-pub-0${count.index + 1}"
  hostname    = "neto-pub-0${count.index + 1}"
  platform_id = var.vms_resources["npub"].platid
  resources {
    cores         = var.vms_resources["npub"].cores
    memory        = var.vms_resources["npub"].memory
    core_fraction = var.vms_resources["npub"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = var.vm_image_id
      size     = var.vms_resources["npub"].bdisksize
      type     = var.vms_resources["npub"].bdisktype
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.net_vpcsub_pub.id
    nat       = true
  }
  metadata = {
    serial-port-enable = var.vms_metadata["metassh"].sport
    ssh-keys           = var.vms_metadata["metassh"].skeys
  }
}
resource "yandex_compute_instance" "platform_netopriv" {
  count       = 1
  name        = "neto-priv-0${count.index + 1}"
  hostname    = "neto-priv-0${count.index + 1}"
  platform_id = var.vms_resources["npriv"].platid
  resources {
    cores         = var.vms_resources["npriv"].cores
    memory        = var.vms_resources["npriv"].memory
    core_fraction = var.vms_resources["npriv"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = var.vm_image_id
      size     = var.vms_resources["npriv"].bdisksize
      type     = var.vms_resources["npriv"].bdisktype
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.net_vpcsub_priv.id
    nat       = false
  }
  metadata = {
    serial-port-enable = var.vms_metadata["metassh"].sport
    ssh-keys           = var.vms_metadata["metassh"].skeys
  }
}
