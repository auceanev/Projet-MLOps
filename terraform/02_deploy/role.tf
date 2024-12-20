# This file creates an IAM role for App Runner to access ECR and pull the image.

resource "aws_iam_role" "app_runner_role" {
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Principal = {
            Service = "build.apprunner.amazonaws.com",
          },
          Action = "sts:AssumeRole",
        },
      ],
    }
  )

}

resource "aws_iam_role_policy_attachment" "app_runner_policy_attachment" {
  role       = aws_iam_role.app_runner_role.name
  policy_arn = aws_iam_policy.app_runner_policy.arn
}

resource "aws_iam_policy" "app_runner_policy" {
  policy = jsonencode(
    {
      Version : "2012-10-17",
      Statement : [
        {
          Action : [
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "ecr:DescribeImages",
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
          ],
          Resource : "*",
          Effect : "Allow",
        },
      ]
    }
  )
}