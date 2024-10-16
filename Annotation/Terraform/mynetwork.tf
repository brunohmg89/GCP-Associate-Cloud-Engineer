# Criar a rede mynetwork
resource "google_compute_network" "mynetwork" {
  name                    = "mynetwork"
  auto_create_subnetworks = "true"
}

# Adicionar uma regra de firewall para permitir tráfego HTTP, SSH, RDP e ICMP em mynetwork
resource "google_compute_firewall" "mynetwork-allow-http-ssh-rdp-icmp" {
  name    = "mynetwork-allow-http-ssh-rdp-icmp"
  network = google_compute_network.mynetwork.self_link
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "3389"]
  }
  allow {
    protocol = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
}

# Criar a instância mynet-us-vm
module "mynet-us-vm" {
  source           = "./instance"
  instance_name    = "mynet-us-vm"
  instance_zone    = "us-east4-a"
  instance_network = google_compute_network.mynetwork.self_link
}

# Criar a instância mynet-eu-vm"
module "mynet-eu-vm" {
  source           = "./instance"
  instance_name    = "mynet-eu-vm"
  instance_zone    = "asia-east1-a"
  instance_network = google_compute_network.mynetwork.self_link
}