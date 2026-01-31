### IAM RESOURCES ###

# используем существующий сервисный аккаунт
data "yandex_iam_service_account" "existing_sa" {
  service_account_id = var.yc_service_account_id
}
