### IAM RESOURCES ###

resource "yandex_iam_service_account" "sa" {
  name        = var.yc_service_account_name
  description = "Service account for Dataproc cluster and related services"

  # защищаем от удаления
  lifecycle {
    prevent_destroy = true
  }
}

resource "yandex_resourcemanager_folder_iam_member" "sa_roles" {
  for_each = toset([
    "storage.admin",
    "dataproc.editor",
    "compute.admin",
    "dataproc.agent",
    "mdb.dataproc.agent",
    "vpc.user",
    "iam.serviceAccounts.user",
    "storage.uploader",
    "storage.viewer",
    "storage.editor"
  ])

  folder_id = var.yc_folder_id
  role      = each.key
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"

  # защищаем от удаления
  lifecycle {
    prevent_destroy = true
  }
}
