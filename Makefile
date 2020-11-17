.PHONY: apply destroy

apply:
	terraform import 'module.nodes.aws_eip.rke_master_eip[0]' eipalloc-0ac77d4187e4c9eec
	terraform import 'module.nodes.aws_eip.rke_worker_eip[0]' eipalloc-090070428a7776151
	terraform apply

destroy:
	terraform state rm 'module.nodes.aws_eip.rke_master_eip'
	terraform state rm 'module.nodes.aws_eip.rke_worker_eip'
	terraform destroy