## Terraform OpenSource GitHub Actions automation template for AWS Proton

Welcome! This repository should help you test how Proton works with Terraform Open Source to provision your infrastructure. In this repository you will find two things:

1. A CloudFormation template (GitHubConfiguration.yaml) that will help you get the underlying roles and permissions set up
2. A GitHub Actions task to run Terraform Open Source based on commits to this repo

If you are looking to find an example of what an AWS Proton Template looks like when authored for Terraform, head over to [aws-samples/aws-proton-terraform-sample-templates](https://github.com/aws-samples/aws-proton-terraform-sample-templates)

## How to:

You will need the following:
- `$ENVIRONMENT_NAME`: the name of the environment you plan to create, this can be any name you would like
- `$REGION`: the region into which you will be deploying this service
- `$GITHUB_USER`: A GitHub account with which you can fork this repository

When you see these strings in the instructions below, you should replace them with the value you have chosen.

1. Create a new repository from this repository
   - If you plan on using this template as a starting point and making changes, this is a Repository Template, so you can just click "Use this template" and a new repository will get created in your account that is an exact copy of this one.
   - If you don't plan on really making any changes, you can also fork this template, and then if/when it is updated you can get those updates.
2. We will be using Github Actions to deploy our Terraform template, and notify Proton of the deployment status. You can see the steps of our workflow in [proton_run.yml](https://github.com/aws-samples/aws-proton-terraform-github-actions-sample/blob/main/.github/workflows/proton_run.yml). Forked repositories do not have Actions enabled by default, see [this page](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/enabling-features-for-your-repository/managing-github-actions-settings-for-a-repository) for information on how to enable them.
3. Ensure you have a CodeStar Connection set up for the account into which you
   forked the repo in the previous step. For information on how to set that up see [this documentation](https://docs.aws.amazon.com/dtconsole/latest/userguide/connections-create.html).
4. Run GitHubConfiguration.yaml through CloudFormation (https://aws.amazon.com/cloudformation/). This will create a role that GitHub Actions will use to provision resources into your account, as well as an S3 bucket to store Terraform Open Source state files. Make sure you use all lowercase names in the stack name, as we will use it to create an S3 bucket to save your state files.
```
aws cloudformation create-stack --stack-name aws-proton-terraform-role-stack \
   --template-body file:///$PWD/GitHubConfiguration.yaml \
   --parameters ParameterKey=FullRepoName,ParameterValue=$GITHUB_USER/aws-proton-terraform-github-actions-sample \
   --capabilities CAPABILITY_NAMED_IAM
```
5. Open the file `env_config.json`. Add a new object to the configuration dictionary where the key is `ENVIRONMENT_NAME`, `role` is the `Role` output from the stack created in (3), and the region with `REGION`. This will tell Terraform the role and region to use for deployments. You can use different roles for each environment by adding them to this file
6. In the same file update `state_bucket` with the `BucketName` output from (3). This will tell Terraform where to store the state file.
7. Commit your changes and push them to your forked repository.
8. At this point, you should register an Environment Template that you wish to deploy. If you need an example, head on over to [aws-samples/aws-proton-terraform-sample-templates](https://github.com/aws-samples/aws-proton-terraform-sample-templates) where there are some options to try out.
9. Register your repository with Proton by following the instructions [here](https://docs.aws.amazon.com/proton/latest/adminguide/ag-create-repo.html)
10. Deploy your environment in Proton by following the instructions using the following commands. Change `GITHUB_USER` to be name of the GitHub account with the forked repository. For more information see the documentation [here](https://docs.aws.amazon.com/proton/latest/adminguide/ag-create-env.html#ag-create-env-pull-request)
```
 aws proton create-environment \
        --name $ENVIRONMENT_NAME \
        --template-name "ENVIRONMENT_TEMPLATE_NAME" \
        --template-major-version "1" \
        --provisioning-repository="branch=main,name=$GITHUB_USER/aws-proton-terraform-github-actions-sample,provider=GITHUB" \
        --spec file:///$PWD/specs/env-spec.yml
```
11. Shortly after you trigger the deployment, come back to your repository to see the Pull Request. Once you merge it, you can go back to Proton and see the updated status of your newly created environment

Feel free to reach out with questions or open a ticket with suggestions in our public roadmap at https://github.com/aws/aws-proton-public-roadmap

Thank you!


## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.

