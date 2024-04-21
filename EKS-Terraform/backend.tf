terraform {
  backend "s3" {
    bucket = "redditclone-eksbucket" 
    key    = "EKS/terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "redditcloneapp-db"
  }
}