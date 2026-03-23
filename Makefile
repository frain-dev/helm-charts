ct:
	ct lint --config ct.yaml --all

docs:
	helm-docs

test-sentinel-template:
	./scripts/verify-redis-sentinel-template.sh

integration-kind-verify:
	./scripts/integration-kind-verify.sh

.PHONY: ct docs test-sentinel-template integration-kind-verify
