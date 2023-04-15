import boto3

from botocore.exceptions import ClientError

def recreateBackendBucket():
    client = boto3.client('s3')
    bucketToStore='terraform-state-my-app-systems'
    try:
       client.head_bucket(Bucket=bucketToStore)
    except ClientError:
               client.create_bucket(Bucket=bucketToStore, ACL='private',CreateBucketConfiguration={
        'LocationConstraint':  'eu-central-1' 
    })
