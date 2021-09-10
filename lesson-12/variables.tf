variable "region" {
  type    = string #by default
  default = "us-east-2"
  #description = ""
}

variable "instance_type" {
  type    = string #by default
  default = "t2.micro"
}

variable "port" {
  type    = list(any) # map, boolean
  default = ["80", "8080", "443"]
}

variable "most_recent" {
  type    = bool
  default = "true"
}

variable "tags" {
  type = map(any)
  default = {
    Owner       = "andrei_matrosau"
    Environment = "Dev"
  }
}

variable "vpc" {
  type = map(any)
  default = {
    Name = "shareVPC"
  }
}
