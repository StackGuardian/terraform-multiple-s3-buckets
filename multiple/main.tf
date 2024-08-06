locals {


bucket-list-with-id = [
    for b in var.bucket-list:
     merge(b, {id = (data.terraform_remote_state.bucket-list[index(data.terraform_remote_state.bucket-list.bucket, b.bucket.value)] != null? data.terraform_remote_state.bucket-list.id : index(var.bucket-list, bucket)+1)})
  #merge(b, {id = data.terraform_remote_state.bucket-list.id
  ]

}


module "s3_bucket" {
  source = "../"
  count = length(var.bucket-list-with-id)

  bucket = var.bucket-list-with-id[count.index].bucket
  block_public_policy = var.bucket-list-with-id[count.index].block_public_policy
  
  }
