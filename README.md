# Data-processing-pipeline-in-AWS
This project deploys a simple event-driven data processing pipeline in AWS using Terraform.

Architecture:
- S3 input bucket.
- AWS Lambda function.
- S3 output bucket.
- S3 event notification.

When a text file is uploaded to the input bucket, the Lambda function is triggered automatically. It reads the file, counts the number of lines and words, and stores the result as a JSON file in the output bucket.  

## Prerequisites

- Linux OS (tested in Debian Trixie)  
- AWS account or AWS Learner Lab access
- AWS CLI installed
- Terraform installed
- Valid AWS credentials configured locally

## AWS credentials

AWS credentials are not stored in this repository.

Configure credentials locally using the AWS shared credentials file:

`~/.aws/credentials`

Example:

[default]  
aws_access_key_id=YOUR_ACCESS_KEY  
aws_secret_access_key=YOUR_SECRET_KEY  
aws_session_token=YOUR_SESSION_TOKEN   

## Deploy

Clone the repository and go to the procject directory.  
`git clone <repository url>`
`cd Data-processing-pipeline-in-AWS`
`terraform init`
`terraform plan`
`terraform apply`

Terraform will create the ZIP package automatically from:  
lambda/lambda_function.py  
This is done with the `archive_file` data source during deployment.  

## How to test it
Create sample file:  

`echo -e "this is test\nthis is the second line" > test.txt`  

Upload file to the input bucket:  

`aws s3 cp test.txt s3://file-pipeline-input-ACCOUNT_ID/ --profile default`  

#see that the --profile matches the profile name set in credentials section.  

Download and inspect the result from the output bucket:  

`aws s3 cp s3://file-pipeline-output-ACCOUNT_ID/processed/test.txt.json result.json --profile default
cat result.json`  

## Cleanup
To remove all created resources:  
`terraform destroy`  

## Known limitations
- This project was tested in AWS Learner Lab.  
- Existing IAM role (LabRole) is used because the learner lab did not allow creating a custom IAM role.
- Lambda function processes text files only.

