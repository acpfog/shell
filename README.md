# My shell scripts for different tasks

### `aws_sync.sh` synchronizes a local folder with a remote S3 bucket connected to CloudFront

Script `aws_sync.sh` was written for syncing files between a Linux server and an AWS S3 bucket.
The bucket is used for a content distribution through AWS CloudFront.
If you want to immediately get an updated object through CloudFront, you need to invalidate this object.
A list of objects for invalidation is getting from a log of aws sync dry run:
```
(dryrun) upload: ../dir1/file1.bin to s3://project-cdn/dir1/file1.bin
(dryrun) upload: ../dir2/file2.bin to s3://project-cdn/dir2/file2.bin
Completed 3 part(s) with ... file(s) remaining
```
For an invalidation call we nead a string with objects separated by spaces:
```
/dir1/file1.bin /dir2/file2.bin
```

### `fix_ssh.sh` updates a path stored in SSH_AUTH_SOCK for screen's sessions

Script `fix_ssh.sh` contains a function for update a path to ssh-agent socket
