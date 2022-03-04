/*
This file is managed by AWS Proton. Any changes made directly to this file will be overwritten the next time AWS Proton performs an update.

To manage this resource, see AWS Proton Resource: arn:aws:proton:us-east-1:617296401743:environment/blog_post_prod

If the resource is no longer is accessible within AWS Proton, it may have been deleted and may require manual cleanup.
*/

output "vpc_arn" {
  value = module.vpc.vpc_arn
}

output "subnet_ids" {
  value = module.vpc.private_subnets
}

output "security_group_id" {
  value = module.vpc.default_security_group_id
}