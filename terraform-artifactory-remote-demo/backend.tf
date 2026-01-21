
terraform {
  required_version = ">= 1.4.0"

  # Use JFrog Artifactory as a Terraform Remote Backend
  backend "remote" {
    # Your JFrog domain (no protocol)
    hostname     = "trialpf4dwg.jfrog.io"

    # The Artifactory Terraform Backend repository key
    organization = "tempstroage-generic-local"

    # Choose one option:
    # A) Use a single, explicit workspace
    workspaces {
      name = "demo-dev"
    }

    # B) Or, use a prefix to map multiple workspaces (uncomment instead of 'name'):
    # workspaces {
    #   prefix = "demo-"
    # }
  }
}
