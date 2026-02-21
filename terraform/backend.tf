terraform {
  backend "s3" {
    bucket         = "eniola-cicd-state-bucket"
    key            = "secure-app-1/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "tf-lock"
    profile        = "east2"
  }
}

