# Autoscaling Launch Configuration
 resource "aws_launch_configuration" "web_lc" {
  name_prefix   = "web-lc-"
  image_id      = var.webservers_ami
  instance_type = var.instance_type
  
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd.x86_64
    systemctl start httpd.service
    systemctl enable httpd.service
    echo “Hello World from $(hostname -f)” > /var/www/html/index.html
    EOF
    
    lifecycle {
    create_before_destroy = true
  }
}
# Autoscaling Group
resource "aws_autoscaling_group" "web-asg" {
  name                 = "web-asg"
  vpc_zone_identifier = var.subnets
  launch_configuration = aws_launch_configuration.web_lc.name
  min_size             = 2
  max_size             = 4

  
  tag {
    key                 = "Name"
    value               = "TestSiteServer"
    propagate_at_launch = true
  }

}
# ALB Target Group attachment
resource "aws_autoscaling_attachment" "web-asg-attachment" {
  autoscaling_group_name = aws_autoscaling_group.web-asg.id
  alb_target_group_arn   = var.target_group_arn
}
# Autoscaling Policy
resource "aws_autoscaling_policy" "web-asg-policy" {
  name                   = "web-asg-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web-asg.name
}
# Cloudwatch Metric Alarm
resource "aws_cloudwatch_metric_alarm" "web-cpu-alarm" {
  alarm_name          = "web-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "90"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web-asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.web-asg-policy.arn]
}
  
