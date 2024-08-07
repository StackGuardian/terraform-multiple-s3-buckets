locals {
  bucket_list_with_id = [
    for b in var.bucket_list:      
        merge (b,{id = length(data.terraform_remote_state.state) > 0  ? coalesce(data.terraform_remote_state.state[0].outputs.bucket_list[b].id, index(var.bucket_list, b) + 1): index(var.bucket_list, b) + 1})      
  ]
}
module "backend_config" {
  source = "Invicton-Labs/backend-config/null"
}


output "backend" {
value = module.backend_config
}


data "terraform_remote_state" "state" {
  count = module.backend_config.backend !=null ? 1 : 0
  backend   = module.backend_config.backend.type
  config    = module.backend_config.backend.config
}



module "s3_bucket" {
  source = "../"
  count = length(local.bucket_list_with_id)

  bucket = local.bucket_list_with_id[count.index].bucket
  block_public_policy = local.bucket_list_with_id[count.index].block_public_policy
  tags = {ID = local.bucket_list_with_id[count.index].id}
  
  }
