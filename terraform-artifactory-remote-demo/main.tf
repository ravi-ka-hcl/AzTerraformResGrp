
terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

provider "random" {}
provider "local" {}

# Generate a random suffix to prove state persistence remotely
resource "random_id" "suffix" {
  byte_length = 4
}

# Create a demo file locally (to see something happen on apply)
resource "local_file" "example" {
  filename = var.output_filename
  content  = "Hello from Terraform! Suffix = ${random_id.suffix.hex}"
}

output "suffix" {
  description = "Random hex saved in remote state"
  value       = random_id.suffix.hex
}
