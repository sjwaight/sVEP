#
# Generic policy documents
#
data "aws_iam_policy_document" "main-apigateway" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

#
# queryVCF Lambda Function
#
data "aws_iam_policy_document" "lambda-queryVCF" {
  statement {
    actions = [
      "SNS:Publish",
    ]
    resources = [
      "${aws_sns_topic.queryGTF.arn}",
      "${aws_sns_topic.queryVCFExtended.arn}",
      "${aws_sns_topic.concat.arn}",
    ]
  }
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
    ]
    resources = ["*"]
  }
}

#
# queryVCFExtended Lambda Function
#
data "aws_iam_policy_document" "lambda-queryVCFExtended" {
  statement {
    actions = [
      "SNS:Publish",
    ]
    resources = [
      "${aws_sns_topic.queryGTF.arn}",
      "${aws_sns_topic.queryVCFExtended.arn}",
      "${aws_sns_topic.concat.arn}",
    ]
  }
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
    ]
    resources = ["*"]
  }
}


#
# queryGTF Lambda Function
#
data "aws_iam_policy_document" "lambda-queryGTF" {
  statement {
    actions = [
      "SNS:Publish",
    ]
    resources = [
      "${aws_sns_topic.pluginConsequence.arn}",
      "${aws_sns_topic.pluginUpdownstream.arn}",
    ]
  }
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    resources = ["*"]
  }

}

#
# pluginConsequence Lambda Function
#
data "aws_iam_policy_document" "lambda-pluginConsequence" {

  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    resources = ["*"]
  }

}

#
# pluginUpdownstream Lambda Function
#
data "aws_iam_policy_document" "lambda-pluginUpdownstream" {

  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "SNS:Publish",
    ]
    resources = [
      "${aws_sns_topic.concat.arn}",
    ]
  }

}

#
# concat Lambda Function
#
data "aws_iam_policy_document" "lambda-concat" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "SNS:Publish",
    ]
    resources = [
      "${aws_sns_topic.concat.arn}",
    ]
  }
}
