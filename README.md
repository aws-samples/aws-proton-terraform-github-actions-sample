## Terraform OpenSource GitHub Actions automation template for AWS Proton

Welcome! This repository should help you test how Proton works with Terraform Open Source to provision your infrastructure. In this repository you will find three things:

1. A CloudFormation template (GitHubConfiguration.yaml) that will help you get the underlying roles and permissions set up
2. A GitHub Actions task to run Terraform Open Source based on commits to this repo
3. An AWS Proton sample template that uses Terraform files to work

## How to:

You will need the following:
- `$ENVIRONMENT_NAME`: the name of the environment you plan to create, this can be any name you would like
- `$REGION`: the region into which you will be deploying this service
- `$TEMPLATE_BUCKET`: An S3 bucket in which you can store your Proton templates
- `$GITHUB_USER`: A GitHub account with which you can fork this repository

When you see these strings in the instructions below, you should replace them with the value you have chosen.

1. Fork this repository into your GitHub account
2. We will be using Github Actions to deploy our Terraform template, and notify Proton of the deployment status. You can see the steps of our workflow in [proton_run.yml](https://github.com/aws-samples/aws-proton-terraform-github-actions-sample/blob/main/.github/workflows/proton_run.yml) and [terraform.yml](https://github.com/aws-samples/aws-proton-terraform-github-actions-sample/blob/main/.github/workflows/terraform.yml). Forked repositories do not have Actions enabled by default, see [this page](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/enabling-features-for-your-repository/managing-github-actions-settings-for-a-repository) for information on how to enable them.
3. Ensure you have a CodeStar Connection set up for the account into which you
   forked the repo in the previous step. For information on how to set that up see [this documentation](https://docs.aws.amazon.com/dtconsole/latest/userguide/connections-create.html).
4. Run GitHubConfiguration.yaml through CloudFormation (https://aws.amazon.com/cloudformation/). This will create a role that GitHub Actions will use to provision resources into your account, as well as an S3 bucket to store Terraform Open Source state files. Make sure you use all lowercase names in the stack name, as we will use it to create an S3 bucket to save your state files.
```
aws cloudformation create-stack --stack-name aws-proton-terraform-role-stack \
   --template-body file:///$PWD/GitHubConfiguration.yaml \
   --parameters ParameterKey=FullRepoName,ParameterValue=GITHUB_USER/aws-proton-terraform-github-actions-sample \
   --capabilities CAPABILITY_NAMED_IAM
```
5. Open the file `env_config.json`. Add a new object to the configuration dictionary where the key is `ENVIRONMENT_NAME`, `role` is the `Role` output from the stack created in (3), and the region with `REGION`. This will tell Terraform the role and region to use for deployments. You can use different roles for each environment by adding them to this file
6. In the same file update `state_bucket` with the `BucketName` output from (3). This will tell Terraform where to store the state file.
7. Commit your changes and push them to your forked repository.
8. Take the sample template and create a Proton environment template by following the instructions. Make sure to replace `TEMPLATE_BUCKET` with the name of the bucket in which you would like to store your Proton templates. For more information see the documentation [here](https://docs.aws.amazon.com/proton/latest/adminguide/template-create.html)
```
tar -zcvf sample-vpc-environment-template.tar.gz sample-templates/sample-vpc-environment-template/
aws s3 cp sample-vpc-environment-template.tar.gz s3://TEMPLATE_BUCKET/sample-vpc-environment-template.tar.gz
rm sample-vpc-environment-template.tar.gz

aws proton create-environment-template --name "sample-vpc-environment-template"
aws proton create-environment-template-version \
        --template-name sample-vpc-environment-template \
        --description "Sample template for setting up a Pull Request environment" \
        --source s3="{bucket=TEMPLATE_BUCKET, key=sample-vpc-environment-template.tar.gz}" \
        --region REGION
aws proton update-environment-template-version \
        --template-name "sample-vpc-environment-template" \
        --major-version "1" \
        --minor-version "0" \
        --status "PUBLISHED" \
        --region REGION
```
9. Register your repository with Proton by following the instructions [here](https://docs.aws.amazon.com/proton/latest/adminguide/ag-create-repo.html)
10. Deploy your environment in Proton by following the instructions [here](https://docs.aws.amazon.com/proton/latest/adminguide/ag-create-env.html#ag-create-env-pull-request). Change `GITHUB_USER` to be name of the GitHub account with the forked repository.
```
 aws proton create-environment \
        --name "ENVIRONMENT_NAME" \
        --template-name "sample-vpc-environment-template" \
        --template-major-version "1" \
        --provisioning-repository="branch=main,name=GITHUB_USER/aws-proton-terraform-github-actions-sample,provider=GITHUB" \
        --spec file:///$PWD/specs/env-spec.yml
```
11. Shortly after you trigger the deployment, come back to your repository to see the Pull Request. Once you merge it, you can go back to Proton and see the updated status of your newly created environment

Feel free to reach out with questions or open a ticket with suggestions in our public roadmap at https://github.com/aws/aws-proton-public-roadmap

Thank you!


## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.

