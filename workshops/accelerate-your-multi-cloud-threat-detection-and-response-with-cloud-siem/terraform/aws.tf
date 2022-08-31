# Base AWS configuration
module "cspm" {
  source = "../../../general/terraform-modules/datadog-cspm-aws"
}

module "cloudtrail" {
  source = "../../../general/terraform-modules/datadog-aws-cloudtrail"
}

# IAM user for the vulnerable application
resource "aws_iam_user" "vulnerableapp" {
  name = "domain-tester-service"
}
resource "aws_iam_access_key" "vulnerableapp" {
  user = aws_iam_user.vulnerableapp.name
}
resource "aws_iam_policy" "policy" {
  name   = "vulnerableapp"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:*", 
        "ec2:*",
        "ssm:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Deny",
      "Action": [
        "ec2:RunInstances",
        "ec2:RunScheduledInstances"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}
resource "aws_iam_user_policy_attachment" "viewonly" {
  user       = aws_iam_user.vulnerableapp.name
  policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
}
resource "aws_iam_user_policy_attachment" "vulnerableapp" {
  user       = aws_iam_user.vulnerableapp.name
  policy_arn = aws_iam_policy.policy.arn
}
