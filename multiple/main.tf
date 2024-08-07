locals {
  bucket-list-with-id = [
    for b in var.bucket-list:
     merge(b, {id = index(var.bucket-list, b)+1})
     #merge(b, {id = (data.terraform_remote_state.state[0].outputs.bucket-list[index(data.terraform_remote_state.state[0].outputs.bucket-list.*.bucket, b.bucket)] != null? data.terraform_remote_state.state[0].outputs.bucket-list.id : index(var.bucket-list, b)+1)})
 
  ]
}
module "backend_config" {
  source = "Invicton-Labs/backend-config/null"
}

output "backend" {
value = module.backend_config.backend
}

data "terraform_remote_state" "state" {
  count = module.backend_config.backend != null ? 1 : 0
  backend   = module.backend_config.backend.type
  config    = module.backend_config.backend.config
}


module "s3_bucket" {
  source = "../"
  count = length(var.bucket-list)

  bucket = var.bucket-list[count.index].bucket
  block_public_policy = var.bucket-list[count.index].block_public_policy
  tags = {ID = (count.index)+1}
  
  }
