#!/usr/bin/env bash
set -euo pipefail

profile="${1:-portfolio-deploy}"
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
project_root="$(cd -- "${script_dir}/.." && pwd)"
cd "${project_root}"

if ! bucket_name="$(terraform output -raw bucket_name)"; then
  printf 'Could not read the bucket_name Terraform output. Apply the infrastructure first.\n' >&2
  exit 1
fi

if ! distribution_id="$(terraform output -raw distribution_id)"; then
  printf 'Could not read the distribution_id Terraform output. Apply the infrastructure first.\n' >&2
  exit 1
fi

if ! aws s3 sync "${project_root}/site" "s3://${bucket_name}" --profile "${profile}" --delete; then
  printf "S3 sync failed. Check the AWS CLI profile '%s' and its permissions.\n" "${profile}" >&2
  exit 1
fi

if ! aws cloudfront create-invalidation --distribution-id "${distribution_id}" --paths '/*' --profile "${profile}"; then
  printf "CloudFront invalidation failed. Check the AWS CLI profile '%s' and its permissions.\n" "${profile}" >&2
  exit 1
fi

if ! site_url="$(terraform output -raw site_url)"; then
  printf 'Could not read the site_url Terraform output.\n' >&2
  exit 1
fi

printf 'Deployment complete: %s\n' "${site_url}"
