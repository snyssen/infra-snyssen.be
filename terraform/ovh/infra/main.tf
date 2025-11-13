data "ovh_me" "account" {}

resource "ovh_vps" "ingress_vps" {
  display_name = "ingress_vps"

  image_id = "45b2f222-ab10-44ed-863f-720942762b6f"

  ovh_subsidiary = data.ovh_me.account.ovh_subsidiary
  plan = [
    {
      duration     = "P1M"
      plan_code    = "vps-2025-model1"
      pricing_mode = "default"

      configuration = [
        {
          label = "vps_datacenter"
          value = "SBG"
        },
        {
          label = "vps_os"
          value = "Ubuntu 25.04"
        }
      ]
    }
  ]

  public_ssh_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHsG51JE70xn3hNMPfJuMJFJ6hUEn9ZEDNZbW5eQNix/"
}
