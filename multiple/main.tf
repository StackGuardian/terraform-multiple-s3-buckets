locals {
bucket-list-with-id = [
    for b in var.bucket-list:
     merge(b, {id = (data.terraform_remote_state.state.outputs.bucket-list[index(data.terraform_remote_state.state.outputs.bucket-list.bucket, b.bucket.value)] != null? data.terraform_remote_state.state.outputs.bucket-list.id : index(var.bucket-list, b.bucket)+1)})
    #merge(b, {id = (previous-bucket-list[index(previous-bucket-list.bucket, b.bucket.value)] != null? previous-bucket-list.id : index(var.bucket-list, b.bucket)+1)})
  ]
}
module "backend_config" {
  source = "Invicton-Labs/backend-config/null"
}

data "terraform_remote_state" "state" {
  backend   = module.backend_config.backend.type
  config    = module.backend_config.backend.config
}

module "s3_bucket" {
  source = "../"
  count = length(local.bucket-list-with-id)

  bucket = local.bucket-list-with-id[count.index].bucket
  block_public_policy = local.bucket-list-with-id[count.index].block_public_policy
  
  }
