T = terraform

init:
	$(T) init

validate:
	$(T) validate

plan:
	$(T) plan

apply:
	$(T) apply -auto-approve

destroy:
	$(T) state rm data.yandex_iam_service_account.existing_sa
	$(T) state rm yandex_iam_service_account_static_access_key.sa-static-key
	$(T) state rm yandex_storage_bucket.data_bucket
	$(T) destroy -auto-approve

clean:
	rm -rf .terraform/
	rm  .terraform.lock.hcl
	rm terraform.tfstate
	rm terraform.tfstate.backup
	rm *.tfstate.*
