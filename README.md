# terraform_if_alternative

# 環境構築
## 1. 環境変数設定
```bash
cp .env.sample .env && cp terraform.tfvars.sample terraform.tfvars
```

.env と terraform.tfvars 内の必要な値を埋める。

## 2. local で gloud コマンドを使えるように設定
install して gcloud config を設定。

## 3. 事前準備 script 実行
```bash
make prepare
```

## 4. Terraform 操作
```bash
make init
```

```bash
make plan
```

```bash
make apply
```

```bash
make destroy
```
