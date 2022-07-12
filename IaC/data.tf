data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]

  filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
      name   = "virtualization-type"
      values = ["hvm"]
  }
}

data "archive_file" "code_revision_package" {
  type = "zip"
  source_dir = local.code_path
  output_path = local.deploy_path
}