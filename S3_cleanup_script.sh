#Step 3: Delete objects, versions and delete Markers from the S3 bucket

#!/bin/bash

bucket_name= "your-aws-bucket-name"

# List all the versions and delete markers
aws s3api list-object-versions --bucket $bucket_name --query 'Versions[].VersionId' --output versions.txt
aws s3api list-object-versions --bucket $bucket_name --query 'DeleteMarkers[].VersionId' --output delete_markers.txt

# Delete all the versions
while IFS=$'\t' read -r key version; do
    if [ -n "$key" ] && [ -n "$version" ]; then
        aws s3api delete-object --bucket "$bucket_name" --key $key --version-id "$version"
    fi  
done < versions.txt


# Delete all the delete markers
while IFS=$'\t' read -r key version; do
    if [ -n "$key" ] && [ -n "$version" ]; then
        aws s3api delete-object --bucket "$bucket_name" --key "$key" --version-id $key --version-id "$version"
    fi
done < delete_markers.txt

# Clean up
rm versions.txt delete_markers.txt

# Delete the S3 bucket
aws s3api delete-bucket --bucket "$bucket_name"

