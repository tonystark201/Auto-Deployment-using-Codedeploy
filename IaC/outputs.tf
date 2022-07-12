
##################
# App DNS
##################
output "alb_hostname" {
  value = module.alb.lb_dns_name
}

output "codedeploy_group_name" {
  value = var.codedeploy_group_name
}

output "codedeploy_app_name" {
  value = var.codedeploy_app_name
}

output "bucket_name" {
  value = aws_s3_bucket.code_revision_bucket.id
}

