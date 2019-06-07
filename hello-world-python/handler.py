import boto3
import time


def hello(event, context):
    #client = boto3.client('s3')
    # return client.list_bucket()
    print("hi!")
    time.sleep(4)
    return "hello yall deux"
