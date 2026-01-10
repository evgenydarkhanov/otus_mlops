### STORAGE RESOURCES ###

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "Static access key for object storage"

  # защищаем от удаления
  lifecycle {
    prevent_destroy = true
  }
}

resource "random_id" "bucket_id" {
  byte_length = 8
}

# записываем ключи в .env, чтобы не потерять
resource "null_resource" "update_env_and_save_keys" {
  provisioner "local-exec" {
    command = <<EOT
      # определяем переменные для access_key и secret_key
      ACCESS_KEY=${yandex_iam_service_account_static_access_key.sa-static-key.access_key}
      SECRET_KEY=${yandex_iam_service_account_static_access_key.sa-static-key.secret_key}

      # заменяем пустые переменные в .env
      sed -i "s/^S3_ACCESS_KEY=.*/S3_ACCESS_KEY=$ACCESS_KEY/" ../.env
      sed -i "s/^S3_SECRET_KEY=.*/S3_SECRET_KEY=$SECRET_KEY/" ../.env
    EOT
  }
  # добавляем зависимости, чтобы команда выполнялась после создания ключей
  depends_on = [
    yandex_iam_service_account_static_access_key.sa-static-key
  ]
}

resource "yandex_storage_bucket" "data_bucket" {
  bucket                = "${var.yc_bucket_name}-${random_id.bucket_id.hex}"
  default_storage_class = var.yc_default_storage_class
  access_key            = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key            = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  force_destroy         = true

  # публичный доступ к бакету
  anonymous_access_flags {
    read = true
    list = true
  }

  # защищаем от удаления
  lifecycle {
    prevent_destroy = true
  }
}

# записываем имя бакета в .env, чтобы не потерять
resource "null_resource" "update_env_and_save_bucket_name" {
  provisioner "local-exec" {
    command = <<EOT
      # определяем переменную BUCKET_NAME с именем бакета
      BUCKET_NAME=${yandex_storage_bucket.data_bucket.bucket}

      # заменяем переменную BUCKET_NAME в .env
      sed -i "s/^S3_BUCKET_NAME=.*/S3_BUCKET_NAME=$BUCKET_NAME/" ../.env
    EOT
  }

  # добавляем зависимости, чтобы команда выполнялась после создания бакета
  depends_on = [
    yandex_storage_bucket.data_bucket
  ]
}
