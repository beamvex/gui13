resource "null_resource" "docker_build" {
  provisioner "local-exec" {
    command = <<EOT
docker build -t gui13:latest ..
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin ${aws_ecr_repository.gui13.repository_url}
docker tag gui13:latest ${aws_ecr_repository.gui13.repository_url}:latest
docker push ${aws_ecr_repository.gui13.repository_url}:latest
EOT
  }
  triggers = {
    repo_url = aws_ecr_repository.gui13.repository_url
    timestamp = timestamp()
  }
}

output "docker_image_tag" {
  value = "gui13:latest"
}