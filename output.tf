output "private_ip" {
  value       = google_compute_instance.instance.network_interface.0.network_ip
  description = "Private IP Address of instance"
}
