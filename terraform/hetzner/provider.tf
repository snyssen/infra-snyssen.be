terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.55"
    }
  }
}

provider "hcloud" { }
