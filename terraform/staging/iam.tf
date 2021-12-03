# IAM Policy
resource "aws_iam_policy" "ses-policy" {
  tags = {
    Name = "${var.env}-${var.project}-ses-policy"
  }
  description = "ses policy"
  policy = <<-EOT
    {
      "Version": "2012-10-17",
      "Statement": [{
        "Action": [
          "ses:SendEmail*",
          "ses:SendRawEmail*",
          "sns:Publish",
          "sns:*SMS*",
          "sns:*PhoneNumber*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }]
    }
  EOT
}

## IAM User
resource "aws_iam_user" "rails-user" {
  name = "${var.env}-${var.project}-rails-user"
}

# IAM Userにポリシーのアタッチ
resource "aws_iam_user_policy_attachment" "ses-attach" {
  user       = aws_iam_user.rails-user.name
  policy_arn = aws_iam_policy.ses-policy.arn
}