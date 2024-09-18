import boto3

s3 = boto3.client('s3')
ssm = boto3.client('ssm')

def lambda_handler(event, context):
    # Fetch the bucket names from SSM Parameter Store
    response = ssm.get_parameter(Name='/my/s3/bucket-list')
    bucket_names = response['Parameter']['Value'].split(',')

    for bucket_name in bucket_names:
        # List all object versions and delete markers for each bucket
        versions_response = s3.list_object_versions(Bucket=bucket_name)

        # Delete all object versions except the latest
        if 'Versions' in versions_response:
            for version in versions_response['Versions']:
                # Skip the latest version by checking 'IsLatest' flag
                if not version.get('IsLatest', False):
                    s3.delete_object(Bucket=bucket_name, Key=version['Key'], VersionId=version['VersionId'])
                    print(f"Deleted older version: {version['Key']} - {version['VersionId']} in {bucket_name}")
        
        # Delete all delete markers (optional, as they do not affect latest version)
        if 'DeleteMarkers' in versions_response:
            for marker in versions_response['DeleteMarkers']:
                s3.delete_object(Bucket=bucket_name, Key=marker['Key'], VersionId=marker['VersionId'])
                print(f"Deleted delete marker: {marker['Key']} - {marker['VersionId']} in {bucket_name}")

        print(f"Cleanup complete for bucket: {bucket_name}")
