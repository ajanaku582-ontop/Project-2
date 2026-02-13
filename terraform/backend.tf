terraform {
backend "s3" {
  bucket  = "eniola-cicd-state-bucket"
  key     = "env/dev1-proj-2/terraform.tfstate"
  region  = "us-east-2"
  encrypt = true
}
}