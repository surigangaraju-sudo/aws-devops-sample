module "networking" {
  source = "../../modules/networking"
}
module "compute" {
  source = "../../modules/compute"

  ami_id            = "ami-0a4d112af46bb0d62"
  subnet_id         = module.networking.public_subnet_id
  security_group_id = module.networking.web_security_group_id
}
module "database" {
  source = "../../modules/database"

  vpc_id = module.networking.vpc_id

  db_subnet_ids = [
    module.networking.private_subnet_a_id,
    module.networking.private_subnet_b_id
  ]
  db_password                = var.db_password
  database_security_group_id = module.networking.database_security_group_id
}
module "load_balancer" {
  source = "../../modules/load-balancer"

  vpc_id = module.networking.vpc_id

  public_subnet_ids = [
    module.networking.public_subnet_id,
    module.networking.public_subnet_b_id
  ]

  security_group_id = module.networking.web_security_group_id

  target_instance_id = module.compute.instance_id
}