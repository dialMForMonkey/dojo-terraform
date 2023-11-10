resource "aws_ecs_cluster" "ecs_cluster" {
  name = "dojo-cluster"
   setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "dojo_task" {
  family                   = "dojo-def-ecs-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  skip_destroy             = true
  
  container_definitions = jsonencode(
[
  {
    "image": "dialmformonkey/dojo-envoy",
    "name": "envoy",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  },
  {
    "image": "dialmformonkey/api-price-cryptocurrencies",
    "name": "price-service",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 8081,
        "protocol":"tcp" 
      }
    ]
  }
])


}


resource "aws_ecs_service" "dojo_ecs_service" {
  name = "dojo-ecs-service"
  cluster = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.dojo_task.arn
  launch_type     = "FARGATE"
  desired_count = 2
  depends_on = [aws_lb_listener.http_listener]

  load_balancer {
    target_group_arn = aws_lb_target_group.tg_dojo.arn
    container_name   = "envoy"
    container_port   = 80
  }

  network_configuration {
    assign_public_ip = false
    subnets = [aws_subnet.subnet_a_private.id, aws_subnet.subnet_b_private.id]
  }
}
