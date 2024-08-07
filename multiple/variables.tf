variable "bucket-list" {
  type        = any
  description = "List of maps containing for each bucket to create the info on 'bucket', 'bucket-region' and 'block_public_policy'"
  default     = {}
}
variable "bucket_region" {
  description = "Region where the bucket should be created"
  type        = string
  default     = ""
}
