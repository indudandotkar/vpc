variable "public" {
   default = ["10.1.0.0/24","10.1.1.0/24","10.1.2.0/24"]
   type =list 
}

variable "private" {
   default = ["10.1.3.0/24","10.1.4.0/24","10.1.5.0/24"] 
   type = list
}


variable "data" {
   default = ["10.1.6.0/24","10.1.7.0/24","10.1.8.0/24"] 
   type = list
}