locals {
  bucket_map = {
    for b in var.bucket_list:      
        b.id => b
  }
}


module "s3_bucket" {
  source = "../"
  for_each = local.bucket_map
  bucket = each.value.bucket
  block_public_policy = each.value.block_public_policy
  tags = {ID = each.value.id}
  
  }
