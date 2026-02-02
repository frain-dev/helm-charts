ct:
	ct lint --config ct.yaml --all

docs:
	helm-docs

.PHONY: ct docs
