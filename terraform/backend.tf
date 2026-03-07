terraform {
<<<<<<< HEAD
backend "s3" {
  bucket  = "eniola-cicd-state-bucket"
  key     = "env/dev1-proj-ii/terraform.tfstate"
  region  = "us-east-2"
  encrypt = true
=======
  backend "s3" {
    bucket         = "eniola-cicd-state-bucket"
    key            = "secure-proj-2/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-locks"
  }
>>>>>>> 65c888eeec0f747f78eca4f7c66a96b9d9237edf
}

