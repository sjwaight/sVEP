import datetime
import json
import os
import subprocess
import time
import sys
import boto3
import codecs
from smart_open_reduced import BufferedOutputBase
#global vars
s3 = boto3.client('s3')
s3Obj = boto3.resource('s3')
dynamodb = boto3.client('dynamodb')
sns = boto3.client('sns')
#environ variables
SVEP_REGIONS = os.environ['SVEP_REGIONS']
SVEP_RESULTS = os.environ['SVEP_RESULTS']
CONCATPAGES_SNS_TOPIC_ARN = os.environ['CONCATPAGES_SNS_TOPIC_ARN']
os.environ['PATH'] += ':' + os.environ['LAMBDA_TASK_ROOT']

def upload_from_file_handle(bucket, key, file_handle):
    print("started writing")
    with BufferedOutputBase(bucket, key) as fout:
        for line in file_handle:
            fout.write(line)

def publishResult(APIid, lastFile, pageNum,context):
    pre = APIid+"_page"
    filename = APIid+"_results.tsv"
    if(len(s3.list_objects_v2(Bucket=SVEP_REGIONS, Prefix=lastFile)['Contents']) == 1):
        if(len(s3.list_objects_v2(Bucket=SVEP_REGIONS, Prefix=pre)['Contents']) == pageNum):
            allFiles = s3.list_objects_v2(Bucket=SVEP_REGIONS, Prefix=pre)['Contents']
            allKeys = [d['Key'] for d in allFiles]
            content = []
            num =0
            for keys in allKeys:
                obj = s3.get_object(Bucket=SVEP_REGIONS, Key=keys)
                body = obj['Body'].read()
                content.append(body)
                num+=1
            result_bucket = s3Obj.Bucket(SVEP_RESULTS)
            print(num)
            upload_from_file_handle(result_bucket, filename, content)
            print(" Done concatenating")
        else:
            print("createPages failed to create one of the page")
            kwargs = {
                'TopicArn': CONCATPAGES_SNS_TOPIC_ARN,
            }
            kwargs['Message'] = json.dumps({'APIid' : APIid,'lastFile' : lastFile,'pageNum' : pageNum})
            print('Publishing to SNS: {}'.format(json.dumps(kwargs)))
            response = sns.publish(**kwargs)
            print('Received Response: {}'.format(json.dumps(response)))
    else:
        print("Still waiting for the last page to be created")
        kwargs = {
            'TopicArn': CONCATPAGES_SNS_TOPIC_ARN,
        }
        kwargs['Message'] = json.dumps({'APIid' : APIid,'lastFile' : lastFile,'pageNum' : pageNum})
        print('Publishing to SNS: {}'.format(json.dumps(kwargs)))
        response = sns.publish(**kwargs)
        print('Received Response: {}'.format(json.dumps(response)))


def lambda_handler(event, context):
    print('Event Received: {}'.format(json.dumps(event)))
    ################test#################
    #message = json.loads(event['Message'])
    #######################################
    message = json.loads(event['Records'][0]['Sns']['Message'])
    APIid = message['APIid']
    lastFile = message['lastFile']
    pageNum = message['pageNum']

    #time.sleep(8)
    publishResult(APIid,lastFile, pageNum,context)