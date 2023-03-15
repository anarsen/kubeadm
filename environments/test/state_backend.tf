terraform {
  backend "gcs" {
    bucket = "mvno-tf-state"
    prefix = "k8s/environments/test/dns"
  }
}
