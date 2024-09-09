provider "google" {
  credentials = file("/home/quiblord/gcpservacc.json")
  project     = "devops-interns"
  region      = "us-central1"
  zone        = "us-central1-a"
}
# MySQL VM Instance
resource "google_compute_instance" "mysql_instance" {
  name         = "furkan-mysql"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.furkan_vpc.name
    subnetwork = google_compute_subnetwork.furkan_subnet.name
    access_config {}
  }

  tags = ["mysql"]

  metadata = {
    ssh-keys = "furkan:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "google_compute_firewall" "allow_mysql" {
  name    = "allow-mysql"
  network = google_compute_network.furkan_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Custom VPC
resource "google_compute_network" "furkan_vpc" {
  name                    = "furkan-vpc"
  auto_create_subnetworks = false
}

# Custom Subnet
resource "google_compute_subnetwork" "furkan_subnet" {
  name          = "furkan-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.furkan_vpc.name
}

# Firewall Rule to Allow SSH
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.furkan_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Optional: Firewall Rule to Allow ICMP (Ping)
resource "google_compute_firewall" "allow_icmp" {
  name    = "allow-icmp"
  network = google_compute_network.furkan_vpc.name

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
}

# Frontend Instance
resource "google_compute_instance" "frontend" {
  name         = "furkan-frontend"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.furkan_vpc.name
    subnetwork = google_compute_subnetwork.furkan_subnet.name
    access_config {}
  }

  tags = ["frontend"]

  metadata = {
    ssh-keys = "furkan:${file("~/.ssh/id_rsa.pub")}"
  }
}
resource "google_compute_firewall" "allow_port_4040" {
  name    = "allow-port-4040"
  network = google_compute_network.furkan_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["4040"]
  }

  source_ranges = ["0.0.0.0/0"]
}


# Backend Instance
resource "google_compute_instance" "backend" {
  name         = "furkan-backend"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.furkan_vpc.name
    subnetwork = google_compute_subnetwork.furkan_subnet.name
    access_config {}
  }

  tags = ["backend"]

  metadata = {
    ssh-keys = "furkan:${file("~/.ssh/id_rsa.pub")}"
  }
}

# Jenkins Instance
resource "google_compute_instance" "jenkins" {
  name         = "furkan-jenkins"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.furkan_vpc.name
    subnetwork = google_compute_subnetwork.furkan_subnet.name
    access_config {}
  }

  tags = ["jenkins"]

  metadata = {
    ssh-keys = "furkan:${file("~/.ssh/id_rsa.pub")}"
    jenkins-port = "8080"
  }
}
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.furkan_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  
  source_ranges = ["0.0.0.0/0"]
}
resource "google_compute_firewall" "allow_backend" {
  name    = "allow-backend"
  network = google_compute_network.furkan_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["8080"]  # Adjust this port as needed
  }

  source_tags = ["frontend"]
  target_tags = ["backend"]
}
resource "google_compute_firewall" "allow_jenkins" {
  name    = "allow-jenkins"
  network = google_compute_network.furkan_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]
}
output "jenkins_ip" {
  value = google_compute_instance.jenkins.network_interface[0].access_config[0].nat_ip
}
output "frontend_ip" {
  value = google_compute_instance.frontend.network_interface[0].access_config[0].nat_ip
}
output "backend_ip" {
  value = google_compute_instance.backend.network_interface[0].access_config[0].nat_ip
}
output "mysql_ip" {
  value = google_compute_instance.mysql_instance.network_interface[0].access_config[0].nat_ip
}