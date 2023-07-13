
resource "google_compute_instance" "app1" {
  name = "application-server=${count.index}"
  machine_type = "f1-micro"
  zone = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"

    access_config {
      egress {
        egress_rule{
          to_port = 0
          to_address = ["0.0.0.0/0"]
        }
      }
    }
  }

  metadata_startup_script = "sudo apt update; sudo apt upgrade -y; sudo apt install nginx -y"

  tags = ["http-server"]
}

resource "google_compute_firewall" "http-server" {
  name = "default-allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["http-server"]
}

resource "google_compute_instance" "db-server" {
  
}
