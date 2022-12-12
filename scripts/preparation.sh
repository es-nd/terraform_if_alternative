#!/bin/bash
# terraform を使用するための事前準備を行う。

echo "start preparation"

# 0. .env を環境変数にセットする。
echo "export envs"
export $(cat .env| grep -v "#" | xargs)

# 1. state管理用バケットの作成
# https://cloud.google.com/storage/docs/gsutil/commands/mb
echo "create bucket"
gsutil mb \
  -b on \
  -c standard \
  -l asia-northeast1 \
  -p $GCP_PROJECT_ID \
  "gs://$GCP_PROJECT_ID-terraform" && \

# 2. サービスアカウントの作成・権限付与
# https://cloud.google.com/sdk/gcloud/reference/iam/service-accounts/create
# アカウント作成
echo "create servie-account"
gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
  --display-name=$SERVICE_ACCOUNT_NAME \
  --description="Service account used by Terraform" \
  --project=$GCP_PROJECT_ID

# 権限付与
## IAMユーザーにサービスアカウントの権限の借用を許可
## https://cloud.google.com/iam/docs/service-accounts?hl=ja#service_account_permissions
echo "start adding iam policy binding"

gcloud projects add-iam-policy-binding $GCP_PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$GCP_PROJECT_ID.iam.gserviceaccount.com" \
  --role=roles/iam.serviceAccountUser

gcloud projects add-iam-policy-binding $GCP_PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$GCP_PROJECT_ID.iam.gserviceaccount.com" \
  --role=roles/storage.admin

echo "end adding iam policy binding"

# 4. サービスアカウトキーの発行
echo "start creating service account key"
gcloud iam service-accounts keys create ./credential.json \
    --iam-account=$SERVICE_ACCOUNT_NAME@$GCP_PROJECT_ID.iam.gserviceaccount.com \
    --project=$GCP_PROJECT_ID

echo "end creating service account key"

# 5. APIの有効化
echo "start enabling apis"
# Cloud Resource Manager API
gcloud services enable cloudresourcemanager.googleapis.com

# Identity and Access Management (IAM) API
gcloud services enable iam.googleapis.com

echo "end enabling apis"

echo "end preparation"
