
locals {
  tags = {
    CreatedBy = "terraform"
    Environment = "CodeDeployDemo"
  }

  module_path        = abspath(path.module)
  code_path        = abspath("${path.module}/../server/")
  deploy_path        = abspath("${path.module}/../deploy.zip")
}