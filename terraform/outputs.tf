output "alb_dns" {
  value = aws_lb.alb.dns_name
}

output "app_ips" {
  value = aws_instance.app[*].public_ip
}

output "redis_ip" {
  value = aws_instance.redis.public_ip
}

output "mysql_ip" {
  value = aws_instance.mysql.public_ip
}

output "monitor_ip" {
  value = aws_instance.monitor.public_ip
}
