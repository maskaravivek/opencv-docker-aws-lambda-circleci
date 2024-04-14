# OpenCV AWS Lambda

Build:

```
docker build --platform linux/amd64 -t opencv-grayscale-image:1.0.0 .
```

Tag:

```
docker tag opencv-grayscale-image:1.0.0 927728891088.dkr.ecr.us-west-2.amazonaws.com/opencv-grayscale-image:1.0.0
```

Push:

```
docker push 927728891088.dkr.ecr.us-west-2.amazonaws.com/opencv-grayscale-image:1.0.0
```

Run locally:

```
docker run --platform linux/amd64 -e AWS_ACCESS_KEY_ID='<YOUR_KEY>' \
-e AWS_SECRET_ACCESS_KEY='<YOUR_ACCESS_KEY>' \
-e AWS_DEFAULT_REGION='us-west-2' \
--env-file .env \
-p 9000:8080 opencv-grayscale-image:1.0.0
```

```
curl "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{"body": "{\"imageUrl\":\"https://picsum.photos/id/237/536/354\"}" }'
```