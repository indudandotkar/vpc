data "aws_availability_zones" "available" {
  state = "available"
}










# to create vpc
resource "aws_vpc" "vpc" {
  cidr_block           = "10.1.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-sharmi"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw.tf"
  }
}


resource "aws_subnet" "indu" {
  vpc_id     = aws_vpc.vpc.id 
  map_public_ip_on_launch = true
  availability_zone = element (data.aws_availability_zones.available.names,count.index)
  cidr_block = element(var.public,count.index)
  count = length(data.aws_availability_zones.available.names)

  tags = {
    Name = "subnet-${count.index+1}-public"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.vpc.id 
  
  availability_zone = element (data.aws_availability_zones.available.names,count.index)
  cidr_block = element(var.private,count.index)
  count = length(data.aws_availability_zones.available.names)

  tags = {
    Name = "subnet-${count.index+1}-private"
  }
}

resource "aws_subnet" "data" {
  vpc_id     = aws_vpc.vpc.id 
  
  availability_zone = element (data.aws_availability_zones.available.names,count.index)
  cidr_block = element(var.data,count.index)
  count = length(data.aws_availability_zones.available.names)

  tags = {
    Name = "subnet-${count.index+1}-data"
  }
}

resource "aws_eip" "eip" {
  
  vpc      = true
}


resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.indu[0].id

  tags = {
    Name = "nat"
  }
}


resource "aws_route_table" "route_public" {
  vpc_id = aws_vpc.vpc.id

 tags = {
    Name = "route_public"
  }
}


resource "aws_route_table" "route_private" {
  vpc_id = aws_vpc.vpc.id

 tags = {
    Name = "route_private"
  }
}


resource "aws_route_table_association" "public" {
  count=length(aws_subnet.indu[*].id)
  subnet_id      = element(aws_subnet.indu[*].id,count.index)
  route_table_id = aws_route_table.route_public.id
}


resource "aws_route_table_association" "private" {
  count=length(aws_subnet.indu[*].id)
  subnet_id      = element(aws_subnet.indu[*].id,count.index)
  route_table_id = aws_route_table.route_private.id


}



resource "aws_route_table_association" "data" {
  count=length(aws_subnet.indu[*].id)
  subnet_id      = element(aws_subnet.indu[*].id,count.index)
  route_table_id = aws_route_table.route_private.id

}












