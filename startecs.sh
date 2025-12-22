#!/usr/bin/env bash
set -euo pipefail

# Start an ECS task with execute command enabled
# Usage: AWS_PROFILE=your-profile ./startecs.sh

export CLUSTER="gui13-cluster"
export TASK_DEFINITION="gui13-app:4"
export SUBNETS="subnet-5b308d17,subnet-af2c0ec6,subnet-8e1d73f4"
export SECURITY_GROUPS="sg-026bc55f10b497637"
export AWS_REGION="eu-west-2"

./run_task_with_exec.sh