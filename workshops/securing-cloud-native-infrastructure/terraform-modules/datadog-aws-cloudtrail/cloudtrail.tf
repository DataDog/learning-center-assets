# Code mostly stolen from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail

resource "aws_cloudtrail" "trail" {
  name                          = "datadog-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail-bucket.id
  s3_key_prefix                 = ""
  include_global_service_events = true # required for multi-region trails
  is_multi_region_trail         = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    // Lambda data events
    dynamic "data_resource" {
      for_each = var.enable-cloudtrail-data-events ? [1] : []
      content {
        type   = "AWS::Lambda::Function"
        values = ["arn:aws:lambda"]
      }
    }

    // S3 data events
    dynamic "data_resource" {
      for_each = var.enable-cloudtrail-data-events ? [1] : []
      content {
        type   = "AWS::S3::Object"
        values = ["arn:aws:s3"]
      }
    }
  }
}

resource "aws_s3_bucket" "cloudtrail-bucket" {
  bucket        = "datadog-cloudtrail-trail-${local.random-suffix}"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "cloudtrail-bucket" {
  bucket = aws_s3_bucket.cloudtrail-bucket.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "${aws_s3_bucket.cloudtrail-bucket.arn}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.cloudtrail-bucket.arn}/AWSLogs/${local.aws-account-id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}


// Notification to forwarder
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = local.forwarder-lambda-arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.cloudtrail-bucket.arn
}

output "a" {
  value = aws_cloudformation_stack.datadog_forwarder.outputs["DatadogForwarderArn"]
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.cloudtrail-bucket.id

  lambda_function {
    lambda_function_arn = local.forwarder-lambda-arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}
