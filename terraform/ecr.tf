resource "aws_ecr_repository" "gui13" {
  name = "gui13eu"
}

resource "aws_ecr_repository_policy" "gui13_policy" {
  repository = aws_ecr_repository.gui13.name
  policy     = data.aws_iam_policy_document.ecr_policy.json
}

data "aws_iam_policy_document" "ecr_policy" {
  statement {
    sid    = "AllowPushPull"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
    ]
  }
}

output "ecr_repository_url" {
  value = aws_ecr_repository.gui13.repository_url
}

output "ecr_repository_name" {
  value = aws_ecr_repository.gui13.name
}