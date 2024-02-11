# OpenCV AWS Lambda

```
docker run --platform linux/amd64 -e AWS_ACCESS_KEY_ID='AKIA5QAHTOTIKVFAEH3V' \
-e AWS_SECRET_ACCESS_KEY='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' \
-e AWS_DEFAULT_REGION='us-west-2' \
--env-file .env \
-p 9000:8080 docker-image:test
```

```
curl "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'
```