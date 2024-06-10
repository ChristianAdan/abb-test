variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  default     = ""
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "db_username" {
  default = "counteruser"
}
variable "db_password" {
    default = "password"
}
variable "db_name" {
  default = "visitorcounter"
}
variable "db_identifier" {
  default = "postgres"
}
