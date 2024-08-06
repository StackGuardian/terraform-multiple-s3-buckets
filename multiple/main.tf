locals {

bucket-list-with-id = [
    for bucket in var.bucket-list:
      merge(bucket, {id = index(var.bucket-list, bucket)+1})
  ]

}


module "s3_bucket" {
  source = "../"
  count = length(var.bucket-list-with-id)

  bucket = var.bucket-list-with-id[count.index].bucket
  block_public_policy = var.bucket-list-with-id[count.index].block_public_policy
  
  }
