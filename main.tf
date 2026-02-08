terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Random Django secret
resource "random_string" "django_secret" {
  length  = 50
  special = true
}

# Lookup ECS task execution role ARN
data "aws_iam_role" "ecs_task_execution" {
  name = var.ecs_task_execution_role_name
}

# Get AWS account ID dynamically
data "aws_caller_identity" "current" {}
