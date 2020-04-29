resource "aws_cloudwatch_log_group" "flowlog" {
  name              = "/flowlogs/${var.environment}"
  retention_in_days = 30

  tags = {
    Name        = var.vpc_name
    Environment = var.environment
  }
}

data "aws_iam_policy_document" "flowlog_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "flowlog" {
  name               = "floglow-${var.environment}"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.flowlog_assume_role.json
}

resource "aws_iam_role_policy" "flowlog" {
  name = "floglow-${var.environment}"
  role = aws_iam_role.flowlog.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "${aws_cloudwatch_log_group.flowlog.arn}"
    }
  ]
}
EOF
}

resource "aws_flow_log" "flowlog" {
  iam_role_arn    = aws_iam_role.flowlog.arn
  log_destination = aws_cloudwatch_log_group.flowlog.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.vpc.id
}
