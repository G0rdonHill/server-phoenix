output "gcp_instance_public_ip" {
  value       = module.gcp_compute.gcp_instance_public_ip
  description = "The public IPs of the GCP Compute instances"
}