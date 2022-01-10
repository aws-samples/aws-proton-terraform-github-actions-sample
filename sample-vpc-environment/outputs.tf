/*
This file is managed by AWS Proton. Any changes made directly to this file will be overwritten the next time AWS Proton performs an update.

To manage this resource, see AWS Proton Resource: arn:aws:proton:us-east-1:615044489287:environment/sample-vpc-environment

If the resource is no longer is accessible within AWS Proton, it may have been deleted and may require manual cleanup.
*/

output "vpc_arn" {
    value = module.vpc.vpc_arn
}

