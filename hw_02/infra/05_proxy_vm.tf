### PROXY VIRTUAL MACHINE RESOURCES ###

resource "yandex_compute_disk" "boot_disk" {
  name     = "boot-disk"
  zone     = var.yc_zone
  image_id = var.yc_image_id
  size     = 30
}

resource "yandex_compute_instance" "proxy_vm" {
  name                      = var.yc_instance_name
  allow_stopping_for_update = true
  platform_id               = var.yc_platform_id
  zone                      = var.yc_zone
  service_account_id        = yandex_iam_service_account.sa.id

  # скрипт, запускающийся при старте VM, передаём в него аргументы
  metadata = {
    ssh-keys  = "ubuntu:${file(var.public_key_path)}"
    user-data = templatefile("${path.root}/scripts/user_data.sh", {
      token                       = var.yc_token
      cloud_id                    = var.yc_cloud_id
      folder_id                   = var.yc_folder_id
      private_key                 = file(var.private_key_path)
      access_key                  = yandex_iam_service_account_static_access_key.sa-static-key.access_key
      secret_key                  = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
      s3_bucket                   = yandex_storage_bucket.data_bucket.bucket
      upload_data_to_hdfs_content = file("${path.root}/scripts/upload_data_to_hdfs.sh")
    })
  }

  scheduling_policy {
    preemptible = true
  }

  resources {
    cores  = var.yc_instance_cores
    memory = var.yc_instance_memory
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot_disk.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  metadata_options {
    gce_http_endpoint = 1
    gce_http_token    = 1
  }

  # подключение по ssh
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    host        = self.network_interface[0].nat_ip_address
  }

  # выполнение действий: сохранение логов
  provisioner "remote-exec" {
    inline = [
      "sudo cloud-init status --wait",
      "echo 'User-data script execution log:' | sudo tee /var/log/user_data_execution.log",
      "sudo cat /var/log/cloud-init-output.log | sudo tee -a /var/log/user_data_execution.log",
    ]
  }
  depends_on = [yandex_dataproc_cluster.dataproc_cluster]
}
