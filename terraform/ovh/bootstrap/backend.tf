terraform {
  backend "s3" {
    bucket   = "infra-snyssen-be-tfstate"
    key      = "ovh/bootstrap.tfstate"
    region   = "eu-central-003"
    endpoint = "https://s3.eu-central-003.backblazeb2.com"

    skip_requesting_account_id  = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_s3_checksum            = true
  }
}
