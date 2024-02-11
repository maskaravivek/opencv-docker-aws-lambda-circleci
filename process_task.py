import cv2
import requests
import boto3
import os

tmp_dir = '/tmp'
S3_BUCKET_NAME = os.environ['S3_BUCKET_NAME']

def convert_image_to_grayscale(image_url):
    tmp_img_path = download_image(image_url)
    output_img_path = f'{tmp_dir}/gray_image.jpg'
    
    image = cv2.imread(tmp_img_path)
    # convert the image to grayscale
    gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    # save the grayscale image to a temporary directory
    cv2.imwrite(output_img_path, gray_image)
    
    # upload the grayscale image to S3
    s3_file_path = upload_image_to_s3(output_img_path)
    return s3_file_path

def download_image(image_url):
    # download image from the internet
    response = requests.get(image_url)
    image = response.content
    
    # save the image to a temporary directory
    with open(f'{tmp_dir}/image.jpg', 'wb') as f:
        f.write(image)
        
    return f'{tmp_dir}/image.jpg'

def upload_image_to_s3(image_path):
    s3 = boto3.client('s3')
    
    s3_file_path = f'gray_images/{os.path.basename(image_path)}'
    
    with open(image_path, 'rb') as f:
        s3.upload_fileobj(f, S3_BUCKET_NAME, s3_file_path)
        
    return s3_file_path