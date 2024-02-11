import json
from process_task import convert_image_to_grayscale
import os

def lambda_handler(event, context):
    request_body = json.loads(event['body'])
    
    image_url = request_body['imageUrl']
    
    gray_image_path = convert_image_to_grayscale(image_url)
    
    return {
        'statusCode': 200,
        'body': json.dumps({
            'grayImagePath': gray_image_path
        })
    }   

if __name__ == "__main__":
    import os
    
    event = {
        'body': json.dumps({
            'imageUrl': 'https://i.imgur.com/afKn8xK.jpg'
        })
    }
    
    context = {}
    
    lambda_handler(event, context)