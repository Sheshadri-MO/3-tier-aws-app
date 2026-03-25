
# ---------------- VPC ----------------
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# ---------------- SUBNETS ----------------
resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-north-1b"
  map_public_ip_on_launch = true
}

# ---------------- INTERNET ----------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "route" {
  route_table_id         = aws_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "a1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "a2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.rt.id
}

# ---------------- SECURITY GROUP ----------------
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 3000
    to_port   = 3000
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 6379
    to_port   = 6379
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ---------------- EC2 ----------------
locals {
  ami = "ami-0c1ac8a41498c1a9c"
}

resource "aws_instance" "app" {
  count         = 2
  ami           = local.ami
  instance_type = "t3.micro"
  key_name      = var.key_name
  subnet_id     = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = "app-${count.index + 1}"
  }
}

resource "aws_instance" "redis" {
  ami           = local.ami
  instance_type = "t3.micro"
  key_name      = var.key_name
  subnet_id     = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = "redis"
  }
}

resource "aws_instance" "mysql" {
  ami           = local.ami
  instance_type = "t3.micro"
  key_name      = var.key_name
  subnet_id     = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = "mysql"
  }
}

resource "aws_instance" "monitor" {
  ami           = local.ami
  instance_type = "t3.micro"
  key_name      = var.key_name
  subnet_id     = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = "monitor"
  }
}

# ---------------- ALB ----------------
resource "aws_lb" "alb" {
  name               = "devops-alb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  security_groups    = [aws_security_group.sg.id]
}

resource "aws_lb_target_group" "tg" {
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group_attachment" "attach" {
  count            = 2
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.app[count.index].id
  port             = 3000
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
 