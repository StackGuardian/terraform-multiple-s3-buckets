locals {

bucket_list_with_id = [
    for bucket in var.bucket_list:
      merge(bucket, {id = index(bucket_list, bucket)+1})
  ]

}


module "s3_bucket" {
  source = "../"
  count = length(var.bucket-list)

  bucket = var.bucket-list[count.index].bucket
  block_public_policy = var.bucket-list[count.index].block_public_policy
  
  }
