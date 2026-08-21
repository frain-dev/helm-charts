ct:
	ct lint --config ct.yaml --all

docs:
	helm-docs

test-sentinel-template:
	./scripts/verify-redis-sentinel-template.sh

test-env-contract-template:
	./scripts/verify-env-contract-template.sh

integration-kind-verify:
	./scripts/integration-kind-verify.sh

.PHONY: ct docs test-sentinel-template test-env-contract-template integration-kind-verify
