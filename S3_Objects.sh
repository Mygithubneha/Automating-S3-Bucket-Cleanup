#Step 2: Adding objects to the S3 bucket

bucket_name= "your-aws-bucket-name"

# upload some objects to the S3 bucket
aws s3 cp ./$bucket_name s3://$bucket_name/file1.txt
aws s3 cp ./$bucket_name s3://$bucket_name/file2.txt
aws s3 cp ./$bucket_name s3://$bucket_name/file3.txt