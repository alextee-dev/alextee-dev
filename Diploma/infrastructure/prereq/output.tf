output "Network_ID" {
  value = yandex_vpc_network.netolab.id
}

output "Subnet-a_ID" {
  value = yandex_vpc_subnet.public-a.id
}

output "Cicd_IP" {
  value = yandex_compute_instance.cicd.network_interface[0].nat_ip_address
}

output "Cicd_agent_IP" {
  value = yandex_compute_instance.cicd-agent.network_interface[0].nat_ip_address
}