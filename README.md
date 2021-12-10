## Terraform OpenSource GitHub Actions automation template for AWS Proton

Welcome! This repository should help you test how Proton works with Terraform Open Source to provision your infrastructure. In this repository you will find three things:

1. A CloudFormation template (GitHubConfiguration.yaml) that will help you get the underlying roles and permissions set up
2. A GitHub Actions task to run Terraform Open Source based on commits to this repo
3. An AWS Proton sample template that uses Terraform files to work

To configure this sample, follow this instructiuons:
1. Clone this repository
2. In the GitHubConfiguration.yaml file, update the input parameters to your username and repository name
3. Run GitHubConfiguration.yaml through CloudFormation (https://aws.amazon.com/cloudformation/). This will create a role that GitHub Actions will use to provision resources into your account, as well as an S3 bucket to store Terraform Open Source state files. Make sure you use all lowercase names in the stack name, as we will use it to create an S3 bucket to save your state files
4. Open the file env_config.json and update the role ARN with the output from (3), the environment name with the name of the environment you are going to create and the region with your preferred deployment region. This will tell Terraform the role and region to use for deployments. You can use different roles for each environment by adding them to this file
5. Open the file .github/workflows/terraform.yml and update the S3 bucket with the output from (3). This will tell Terraform where to store the state file
6. Take the sample template and create a Proton environment template by following the instructions here https://docs.aws.amazon.com/proton/latest/adminguide/template-create.html
7. Register your repository with Proton by following the instructions here: https://docs.aws.amazon.com/proton/latest/adminguide/ag-repositories.html
8. Deploy your environment in Proton by following the instructions here: https://docs.aws.amazon.com/proton/latest/adminguide/ag-environments.html
9. Sortly after you trigger the deployment, come back to your repository to see the Pull Request. Once you merge it, you can go back to Proton and see the updated status of your newly created environment

Fell free to reach out with questions or open a ticket with suggestions in our public roadmap at https://github.com/aws/aws-proton-public-roadmap

Thank you!


## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.

