resource "ovh_me_api_oauth2_client" "terraform_client" {
  name        = "terraform"
  description = "terraform credentials for IaC at https://github.com/snyssen/infra-snyssen.be"
  flow        = "CLIENT_CREDENTIALS"
}

resource "local_sensitive_file" "provider_ovh" {
  filename = "../infra/provider_ovh.tf"
  content  = <<EOF
provider "ovh" {
  endpoint      = "ovh-eu"
  client_id     = "${ovh_me_api_oauth2_client.terraform_client.client_id}"
  client_secret = "${ovh_me_api_oauth2_client.terraform_client.client_secret}"
}
  EOF
}
