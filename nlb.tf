resource "aws_lb" "nlb_dojo" {
    name               = "nlb-dojo"
    load_balancer_type = "network"
    subnets            = [aws_subnet.subnet_a_public.id, aws_subnet.subnet_b_public.id]
    enable_cross_zone_load_balancing = true
    
    internal    = false
    tags = {
        Environment = "training"
    }
}

resource "aws_lb_target_group" "tg_dojo" {
  name        = "target-group-dojo"
  port        = 80
  load_balancing_cross_zone_enabled = true
  target_type = "ip"
  protocol    = "TCP"
  vpc_id      = aws_vpc.dojovpc.id

  health_check {
    port = 80
    enabled = true
    protocol = "TCP"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.nlb_dojo.arn
  port              = "80"
  protocol          = "TCP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_dojo.arn
  }
}

