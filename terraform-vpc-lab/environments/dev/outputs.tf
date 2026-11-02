output "vpc_id" {
  value = module.networking.vpc_id
}

output "instance_id" {
  value = module.compute.instance_id
}

output "instance_public_ip" {
  value = module.compute.instance_public_ip
}

output "alb_dns_name" {
  value = module.load_balancer.alb_dns_name
}

output "db_endpoint" {
  value = module.database.db_endpoint
}