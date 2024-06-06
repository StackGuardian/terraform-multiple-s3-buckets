module "s3_bucket" {
  source = "../"
  count = length(var.bucket-list)

  bucket = var.bucket-list[count.index].bucket
  block_public_policy = var.bucket-list[count.index].block_public_policy
  
  }
