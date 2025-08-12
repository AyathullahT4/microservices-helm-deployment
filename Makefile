CHART := .
RELEASE := ms
NAMESPACE := web

.PHONY: render-dev render-prod install-dev install-prod uninstall status

render-dev:
	helm template $(RELEASE) $(CHART) -n $(NAMESPACE) -f values.yaml -f values.dev.yaml > out-dev.yaml

render-prod:
	helm template $(RELEASE) $(CHART) -n $(NAMESPACE) -f values.yaml -f values.prod.yaml > out-prod.yaml

install-dev:
	helm upgrade --install $(RELEASE) $(CHART) -n $(NAMESPACE) --create-namespace -f values.yaml -f values.dev.yaml

install-prod:
	helm upgrade --install $(RELEASE) $(CHART) -n $(NAMESPACE) --create-namespace -f values.yaml -f values.prod.yaml

uninstall:
	helm uninstall $(RELEASE) -n $(NAMESPACE) || true

status:
	kubectl -n $(NAMESPACE) get deploy,svc,ing,pods

.PHONY: images-dev port-forward smoke

images-dev:
	./tools/build-images.sh

port-forward:
	kubectl -n ingress-nginx port-forward svc/ingress-nginx-controller 8080:80

smoke:
	curl -s -H "Host: app.local" http://127.0.0.1:8080/api/node/health
	curl -s -H "Host: app.local" http://127.0.0.1:8080/api/python/health
