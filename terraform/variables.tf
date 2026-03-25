variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "key_name" {
  description = "AWS EC2 Key Pair Name"
  type        = string
}
