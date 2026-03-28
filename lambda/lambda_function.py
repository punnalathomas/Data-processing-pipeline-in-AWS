import json
import os
from datetime import datetime
import boto3

s3 = boto3.client("s3")

OUTPUT_BUCKET = os.environ["OUTPUT_BUCKET"]

def lambda_handler(event, context):
    record = event["Records"][0]
    input_bucket = record["s3"]["bucket"]["name"]
    input_key = record["s3"]["object"]["key"]

    response = s3.get_object(Bucket=input_bucket, Key=input_key)
    content = response["Body"].read().decode("utf-8")

    line_count = len(content.splitlines())
    word_count = len(content.split())

    result = {
        "source_bucket": input_bucket,
        "source_key": input_key,
        "line_count": line_count,
        "word_count": word_count,
        "processed_at": datetime.now().isoformat()
    }

    output_key = f"processed/{input_key}.json"

    s3.put_object(
        Bucket=OUTPUT_BUCKET,
        Key=output_key,
        Body=json.dumps(result, indent=2),
        ContentType="application/json"
    )

    return {
        "statusCode": 200,
        "body": json.dumps(result)
    }