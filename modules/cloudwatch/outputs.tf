output "unhealthy_host_alarm_arn" {
  value = aws_cloudwatch_metric_alarm.unhealthy_host.arn
}

output "high_cpu_alarm_arn" {
  value = aws_cloudwatch_metric_alarm.high_cpu.arn
}