#!/usr/bin/env bash
set -euo pipefail

# Required env vars:
#   CLUSTER            e.g. gui13-cluster
#   TASK_DEFINITION    e.g. gui13-app (or full arn, or gui13-app:REV)
#   SUBNETS            comma-separated subnet IDs, e.g. subnet-aaa,subnet-bbb
#   SECURITY_GROUPS    comma-separated sg IDs, e.g. sg-111,sg-222
#
# Optional:
#   CONTAINER          container name to exec into (default: app)
#   COMMAND            command to run in container (default: /bin/sh)
#   LAUNCH_TYPE        default: FARGATE
#   ASSIGN_PUBLIC_IP   ENABLED|DISABLED (default: ENABLED)
#   AWS_REGION         if not set, awscli default config is used

: "${CLUSTER:?Set CLUSTER}"
: "${TASK_DEFINITION:?Set TASK_DEFINITION}"
: "${SUBNETS:?Set SUBNETS (comma-separated subnet IDs)}"
: "${SECURITY_GROUPS:?Set SECURITY_GROUPS (comma-separated sg IDs)}"

CONTAINER="${CONTAINER:-app}"
COMMAND="${COMMAND:-/bin/bash}"
LAUNCH_TYPE="${LAUNCH_TYPE:-FARGATE}"
ASSIGN_PUBLIC_IP="${ASSIGN_PUBLIC_IP:-ENABLED}"

OVERRIDES_ARGS=()

AWS_REGION_ARGS=()
if [[ -n "${AWS_REGION:-}" ]]; then
  AWS_REGION_ARGS=(--region "$AWS_REGION")
fi

NETWORK_CONFIGURATION="awsvpcConfiguration={subnets=[${SUBNETS}],securityGroups=[${SECURITY_GROUPS}],assignPublicIp=${ASSIGN_PUBLIC_IP}}"

echo "Starting task on cluster=${CLUSTER} taskDefinition=${TASK_DEFINITION} ..."
TASK_ARN="$(
  aws ecs run-task \
    "${AWS_REGION_ARGS[@]}" \
    --cluster "$CLUSTER" \
    --task-definition "$TASK_DEFINITION" \
    --launch-type "$LAUNCH_TYPE" \
    "${OVERRIDES_ARGS[@]}" \
    --network-configuration "$NETWORK_CONFIGURATION" \
    --query 'tasks[0].taskArn' \
    --output text
)"

if [[ -z "$TASK_ARN" || "$TASK_ARN" == "None" ]]; then
  echo "Failed to start task (no taskArn returned)." >&2
  exit 1
fi

echo "Task ARN: $TASK_ARN"
echo "Waiting until task is RUNNING..."
aws ecs wait tasks-running "${AWS_REGION_ARGS[@]}" --cluster "$CLUSTER" --tasks "$TASK_ARN"
