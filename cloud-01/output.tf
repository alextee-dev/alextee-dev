output "Pubilc_VM_IP" {
  value = yandex_compute_instance.pub-vm.network_interface[0].nat_ip_address
}

output "Private_VM_IP" {
  value = yandex_compute_instance.priv-vm.network_interface[0].ip_address
}
