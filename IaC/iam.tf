
###################
# EC2 Code deploy role
###################
resource "aws_iam_role" "ec2codedeploy_role" {
  name = "ec2codedeploy_demo"

  assume_role_policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
  )

  tags = local.tags
}

###################
# EC2 access policy
###################
resource "aws_iam_policy" "ec2_access" {
  name        = "ec2_access_demo1"
  path        = "/"
  description = "AmazonEC2FullAccess Policy"

  policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "cloudwatch:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "autoscaling:*",
            "Resource": "*"
        }
      ]
    }
  )

  tags = local.tags
}

###################
# S3 access policy
###################
resource "aws_iam_policy" "s3_access" {
  name        = "s3_access_demo1"
  path        = "/"
  description = "AmazonS3FullAccess Policy"

  policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Action": [
                  "s3:*"
              ],
              "Resource": "*"
          }
      ]
    }
  )

  tags = local.tags
}

###################
# Attach ec2 access to EC2 codedeploy role
###################
resource "aws_iam_role_policy_attachment" "ec2_fullaccess_attach" {
  role       = aws_iam_role.ec2codedeploy_role.name
  policy_arn = aws_iam_policy.ec2_access.arn
}

###################
# Attach s3 access to EC2 codedeploy role
###################
resource "aws_iam_role_policy_attachment" "ec2_s3fullaccess_attach" {
  role       = aws_iam_role.ec2codedeploy_role.name
  policy_arn = aws_iam_policy.s3_access.arn
}

###################
# IAM instance profile using EC2 codedeploy role
###################
resource "aws_iam_instance_profile" "ec2_cd_instance_profile" {
  name = "ec2_cd_instance_profile"
  role = aws_iam_role.ec2codedeploy_role.name
}

###################
# Code Deploy Role
###################
resource "aws_iam_role" "codedeploy_role" {
  name = "codedeploy_role"

  assume_role_policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "",
          "Effect": "Allow",
          "Principal": {
            "Service": "codedeploy.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    }
  )

  tags = local.tags

}


###################
# Attach codedepoly policy to Code Deploy role
###################
resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role    = aws_iam_role.codedeploy_role.name
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess"
  role    = aws_iam_role.codedeploy_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2RoleforAWSCodeDeploy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
  role    = aws_iam_role.codedeploy_role.name
}
