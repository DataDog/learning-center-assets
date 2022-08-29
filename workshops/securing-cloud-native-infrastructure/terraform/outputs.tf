output "app_url" {
  value = module.ecs.app_url
}

output "vpc_id" {
  value = module.ecs.vpc_id
}

output "snapshot_id" {
  value = aws_ebs_snapshot.snapshot.id
}
