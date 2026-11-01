param(
    [string]$Profile = "portfolio-deploy"
)

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
Push-Location $ProjectRoot

try {
    $BucketName = terraform output -raw bucket_name
    if ($LASTEXITCODE -ne 0) {
        throw "Could not read the bucket_name Terraform output. Apply the infrastructure first."
    }

    $DistributionId = terraform output -raw distribution_id
    if ($LASTEXITCODE -ne 0) {
        throw "Could not read the distribution_id Terraform output. Apply the infrastructure first."
    }

    aws s3 sync (Join-Path $ProjectRoot "site") "s3://$BucketName" --profile $Profile --delete
    if ($LASTEXITCODE -ne 0) {
        throw "S3 sync failed. Check the AWS CLI profile '$Profile' and its permissions."
    }

    aws cloudfront create-invalidation --distribution-id $DistributionId --paths "/*" --profile $Profile
    if ($LASTEXITCODE -ne 0) {
        throw "CloudFront invalidation failed. Check the AWS CLI profile '$Profile' and its permissions."
    }

    Write-Host "Deployment complete: $(terraform output -raw site_url)"
}
finally {
    Pop-Location
}
