#!/usr/bin/env bash
set -e

INPUT_BUCKET=$(terraform output -raw input_bucket_name)
OUTPUT_BUCKET=$(terraform output -raw output_bucket_name)

echo -e "this is test\nthis is the second line" > test.txt

aws s3 cp test.txt s3://$INPUT_BUCKET/

sleep 5

aws s3 cp "s3://$OUTPUT_BUCKET/processed/test.txt.json" result.json

cat result.json