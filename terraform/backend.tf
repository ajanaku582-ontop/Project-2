terraform {
  backend "s3" {
    bucket         = "eniola-cicd-state-bucket"
    key            = "secure-proj-2/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-locks"
  }
}

