
# App Server
resource "google_compute_instance" "app1" {
  name = "application1-server"
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
      
    }
  }

  metadata_startup_script = "sudo apt update; sudo apt upgrade -y; sudo apt install nginx -y"

  tags = ["http-server"]
}

# Firewall settings for app 1
resource "google_compute_firewall" "app1-server" {
  name = "default-allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["http-server"]
}

# App 2

resource "google_compute_instance" "app2" {
  name = "application2-server"
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
      
    }
  }

  metadata_startup_script = "sudo apt update; sudo apt upgrade -y; sudo apt install nginx -y"

  tags = ["http-server"]
}

# Firewall settings for app2
resource "google_compute_firewall" "app2-server" {
  name = "default-allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["80","22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["http-server"]
}

resource "google_compute_instance" "db_master" {
  name = "db-master"
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
      
    }
  }
}

resource "google_compute_firewall" "database-server-access" {
  name = "default-allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["3306","22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["database-server"]
}

resource "google_compute_instance" "db_replica" {
  name = "db-replica"
  machine_type = "f1-micro"
  zone = "us-cenral1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"
    access_config {
      
    }
  }

  metadata = {
    "google-compute-engine-disk-encryption-key" = var.gcp_db_server_encryption_key
  }

  depends_on = [google_compute_instance.db_master]
}

resource "google_compute_firewall" "database-replica-server" {
  name = "default-allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["3306", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["database-server"]
}