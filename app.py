import json
from process_task import process_image
import os

def lambda_handler(event, context):
    for record in event['Records']:
        request = json.loads(record['body'])
        process_image(request=request)

if __name__ == "__main__":
    import os
    SAMPLE_JOB_ID = os.environ.get('SAMPLE_JOB_ID')
    process_image({
        'jobId': SAMPLE_JOB_ID
    })