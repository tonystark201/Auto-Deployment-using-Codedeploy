
resource "random_pet" "code_revision_bucket_name" {
  prefix = "codedeploy"
  length = 4
}

###################
# S3 Bucket for code revision
###################
resource "aws_s3_bucket" "code_revision_bucket" {
  bucket = random_pet.code_revision_bucket_name.id
  force_destroy = true
}

resource "aws_s3_bucket_acl" "code_revision_bucket_acl" {
  bucket = aws_s3_bucket.code_revision_bucket.id
  acl    = "private"
}


resource "aws_s3_object" "code_revision" {
  bucket = aws_s3_bucket.code_revision_bucket.id
  key    = var.s3_key
  source = data.archive_file.code_revision_package.output_path
  etag = filemd5(data.archive_file.code_revision_package.output_path)
}