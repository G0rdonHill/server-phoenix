variable "project" {
  type = string
  description = "GCP Project ID"
  default = "gh-test-project-1-276520"
  
}
variable "region" {
  type = string
  description = "Region for the GCP resources"
  default = "us-central1"

}

variable "zone" {
  type = string
  description = "Zone for the GCP resources"
  default = "us-central1-c"

}
variable "credentials" {
  type = string
  description="File location for SA Key"
  default="./gh-test-sa-1-key.json"
}