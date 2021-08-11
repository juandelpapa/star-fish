# Use the customer packer image in the launch template
resource "aws_launch_template" "marine" {
  name_prefix   = "marine"
  image_id      = data.aws_ami.marine.id
  instance_type = "t2.nano"
  key_name = "marine"
  vpc_security_group_ids = [ module.security_group.security_group_id ]
}

# The ASG
resource "aws_autoscaling_group" "marine" {
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  vpc_zone_identifier  = [data.aws_subnet.private.id]

  launch_template {
    id      = aws_launch_template.marine.id
    version = "$Latest"
  }
  target_group_arns    = [ aws_lb_target_group.marine.arn ]
}

# SG to allow SSH only
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "marine-sg"
  vpc_id      = data.aws_vpc.vpc.id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp"]
  egress_rules        = ["all-all"]
}

# NLB stuff
resource "aws_lb" "marine" {
  name               = "marine"
  internal           = false
  load_balancer_type = "network"
  subnets            = data.aws_subnet.public.*.id
  enable_cross_zone_load_balancing = "true"
}

# Listener for SSH
resource "aws_lb_listener" "marine" {
  load_balancer_arn = aws_lb.marine.arn
  port              = "22"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.marine.arn
  }
}

# Target Group
resource "aws_lb_target_group" "marine" {
  name     = "marine"
  port     = 22
  protocol = "TCP"
  vpc_id   = data.aws_vpc.vpc.id
}

resource "aws_autoscaling_attachment" "marine" {
  autoscaling_group_name = aws_autoscaling_group.marine.name
  alb_target_group_arn   = aws_lb_target_group.marine.arn
}
