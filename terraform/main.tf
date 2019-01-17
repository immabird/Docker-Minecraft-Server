provider "google" {
  project = "minecraft-228318"
  region  = "us-east1"
}

resource "google_compute_network" "minecraft-server-network" {
  name                    = "minecraft-server-network"
  auto_create_subnetworks = false
}

resource "google_compute_firewall" "allow-minecraft" {
  name          = "allow-minecraft"
  network       = "${google_compute_network.minecraft-server-network.name}"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["25565", "22"]
  }
}

resource "google_compute_subnetwork" "minecraft-subnetwork" {
  name          = "minecraft-subnetwork"
  ip_cidr_range = "10.0.0.0/16"
  network       = "${google_compute_network.minecraft-server-network.name}"
}

resource "google_compute_instance" "minecraft-server-vm" {
  name         = "minecraft-server-vm"
  zone         = "us-east1-b"
  machine_type = "n1-standard-2"

  boot_disk {
    initialize_params {
      size  = 10
      type  = "pd-standard"
      image = "gce-uefi-images/cos-stable"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.minecraft-subnetwork.name}"

    access_config {}
  }
}
