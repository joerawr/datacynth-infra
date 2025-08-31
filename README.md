# Datacynth Infra: Your Low-Cost AWS Dev & Prod Playground

Welcome! The goal of this repository is to quickly and cheaply spin up two AWS environments that mimic a development (`dev`) and production (`prod`) setup. It's perfect for testing and simulations without breaking the bank.

This project leverages the [datacynth-tf-modules](https://github.com/joerawr/datacynth-tf-modules) to keep the configuration clean and reusable.

## A Quick Note on Cost

We're all about saving money here. The key cost-saving measure is using a `t4g.micro` NAT Instance, which is significantly cheaper than a managed NAT Gateway and fits within the AWS Free Tier.

**Friendly reminder:** Don't forget to power down your EC2 instances when you're not using them!

---

## Getting Started: Prerequisites

This guide assumes you're starting from scratch.

### 1. Two New AWS Accounts

You'll need two separate, brand-new AWS accounts to get the most out of the free tier. When signing up, you'll likely need:

- Two different email addresses
- Two different credit cards
- Two different phone numbers (for verification)

### 2. Configure AWS CLI Profiles

On your local machine, you'll need to configure your AWS credentials. We'll use two named profiles to keep things separate.

- Create an IAM user in your **first account** and configure it as `devadmin`.
- Create an IAM user in your **second account** and configure it as `prodadmin`.

You can do this by running `aws configure --profile devadmin` and `aws configure --profile prodadmin`.

### 3. IAM Permissions

For Terraform to do its thing, the IAM users you created will need some permissions. The list below is a shortcut for quick setup. For any real-world scenario, you should always follow the principle of least privilege.

- `AmazonEC2ContainerRegistryFullAccess`
- `AmazonEC2FullAccess`
- `AmazonECS_FullAccess`
- `AmazonS3FullAccess`
- `AmazonVPCFullAccess`
- `IAMFullAccess`

You can test your profiles by running `aws s3 ls --profile devadmin`, which should return nothing if the account is new.

---

## Setup & Deployment

This project was last tested with Terraform `v1.12.2`. If you need to install it, you can find official instructions on the [HashiCorp releases page](https://developer.hashicorp.com/terraform/downloads).

### 1. Create the Terraform State Buckets

Terraform needs a place to store its state, and we'll be using an S3 bucket in each account. This is a one-time setup step handled by a script.

- **Open `create_backend_s3_bucket.sh`** and review the variables at the top. Make any changes if needed (though the defaults should be fine).
- **Run the script:** `./create_backend_s3_bucket.sh`

> **Why a script?** Creating the state bucket with Terraform is a classic "chicken and the egg" problem. Where would the state for creating the bucket go? A simple script is a clean way to solve this for a new setup.

### 2. Configure Your Environments

In both the `dev/` and `prod/` directories, you'll find a `terraform.tfvars` file. This is where you'll set the unique name for your environment.

- **Required:** Change the `name` variable in `dev/terraform.tfvars` and `prod/terraform.tfvars`.
- **Optional:** You can also change the default IP ranges (`vpc_cidr`) if you have a preference. The defaults are `10.0.0.0/24` for dev and `10.1.0.0/24` for prod.

### 3. Deploy with Terraform

Now you're ready to apply the configuration. Run the following commands for each environment.

**For the Dev Environment:**
```bash
cd dev
terraform init
terraform plan
terraform apply
```

**For the Prod (Production) Environment:**
```bash
cd ../prod
terraform init
terraform plan
terraform apply
```

And that's it! You now have two separate, low-cost AWS environments to work with.
