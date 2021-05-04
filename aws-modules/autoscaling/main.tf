# Autoscaling Launch Configuration
 resource "aws_launch_configuration" "web_lc" {
  name_prefix   = "web-lc-"
  image_id      = var.webservers_ami
  instance_type = var.instance_type

  user_data = <<-EOF
  #!/bin/bash
  
  ##### Install HTTPD
    yum update -y
    yum install -y httpd.x86_64
    systemctl start httpd.service
    systemctl enable httpd.service

    ##### Constants

    TITLE="Hello World!"
    RIGHT_NOW="$(date +"%x %r %Z")"
    TIME_STAMP="$RIGHT_NOW"


    ##### Main

    cat > /var/www/html/index.html<<- _EOF_

    <html>
    <head>
        <title>$TITLE</title>
    </head>

    <body>
        <h1>$TITLE</h1>

        <p>$TIME_STAMP</p>
        <p>This website was created with Terraform with the following AWS resources:</p>
        <p>aws_vpc<p>
        <p>aws_subnet x2<p>
        <p>aws_route_table_association x2<p>
        <p>aws_route_table<p>
        <p>aws_internet_gateway<p>
        <p>aws_default_security_group<p>
        <p>aws_security_group<p>
        <p>aws_alb_target_group<p>
        <p>aws_alb_listener x2<p>
        <p>aws_alb<p>
        <p>aws_launch_configuration<p>
        <p>aws_cloudwatch_metric_alarm<p>
        <p>aws_autoscaling_policy<p>
        <p>aws_autoscaling_group<p>
        <p>aws_autoscaling_attachment<p>
    </body>
  </html>
_EOF_
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
  
