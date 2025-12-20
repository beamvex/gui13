data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "gui13" {
  name        = "gui13-security-group"
  description = "Security group for GUI13 application"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "security_group_id" {
  value = aws_security_group.gui13.id
  description = "The ID of the security group"
}
