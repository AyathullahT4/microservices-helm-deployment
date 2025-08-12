# Microservices Helm Deployment

A self-contained, production-style Helm chart deploying two containerized microservices (Node.js + Python) with ingress routing, health checks, and environment-specific configs. Designed for both local development (Kind) and cloud-ready rollouts.

---

## Overview

**Services**
- **api-node** — Node.js Express app with `/health`
- **api-python** — Python Flask app with `/health`

**Kubernetes Objects**
- Deployments & ClusterIP Services
- Ingress-NGINX with path rewrite
- HorizontalPodAutoscaler (HPA) in production mode

**Config Profiles**
- `values.yaml` — base settings
- `values.dev.yaml` — local development (Kind)
- `values.prod.yaml` — production (resource limits, HPA)

---

## Architecture

<img width="865" height="438" alt="image" src="https://github.com/user-attachments/assets/02b3c7d5-c668-482f-9562-a026af8dc429" />


---

## Quick Start (Dev with Kind)

```bash
# 1. Build and load local images into your Kind cluster
make images-dev CLUSTER=kdev

# 2. Deploy using Helm (namespace: web)
make install-dev

# 3. Port-forward ingress controller
make port-forward
```

---

## Smoke Test

```bash
$ make smoke
curl -s -H "Host: app.local" http://127.0.0.1:8080/api/node/health
{"ok":true,"service":"node"}
curl -s -H "Host: app.local" http://127.0.0.1:8080/api/python/health
{"ok":true,"service":"python"}
```

---

## Operations

```bash
# View all workloads in namespace
kubectl -n web get deploy,svc,ing

# Check rollout status
kubectl -n web rollout status deploy/ms-api-node
kubectl -n web rollout status deploy/ms-api-python

# Tail logs
kubectl -n web logs deploy/ms-api-node --tail=50
```

---

## Environments
```bash
	•	values.dev.yaml
	•	Local development configuration
	•	imagePullPolicy: Never
	•	Tags: api-node:v0.1.0, api-python:v0.1.0
	•	values.prod.yaml
	•	Resource requests/limits
	•	HPA configuration
	•	Fixed, registry-hosted image tags
```

---

## Operational Notes 

```bash
Make Targets
	•	make images-dev — Build & load dev images into local kind cluster
	•	make install-dev — Deploy dev environment
	•	make port-forward — Expose ingress locally
	•	make smoke — Run quick health checks
	•	make uninstall — Remove release

Security
	•	No secrets stored in repo
	•	TLS/WAF can be attached at ingress level in cloud
	•	Minimal RBAC: default service account, no privileged containers

Cost Awareness
	•	Single ingress controller
	•	Scale-to-zero not enabled, but can be added for dev/staging
	•	Prod overlay sets explicit replica counts & autoscaling
 ```

---

## Troubleshooting
```bash
503 from ingress → No ready endpoints. Check:
kubectl -n web get endpoints
kubectl -n web get pods

ImagePullBackOff in dev → Ensure local images are built & loaded:
make images-dev && make install-dev

Port conflict on 8080 → Use a different port in make port-forward
```

----

## Why This Exists
	•	Demonstrates microservice decomposition with centralized ingress.
	•	Shows environment-specific deployments with Helm values.
	•	Includes readiness/liveness checks, autoscaling, and namespace isolation.
	•	Provides a clear base for CI/CD integration without altering app code.
## Why This Chart Matters
	•	Ingress strategy — clean API routing without exposing service internals
	•	Environment overlays — safe drift between dev and prod
	•	Image policy — never pull in dev; pinned tags in prod
	•	Scale control — HPA in prod with conservative defaults

---

## Notes
	•	No secrets stored in repo; all manifests safe to publish.
	•	Dev mode requires Kind cluster (CLUSTER name configurable).
	•	Replace app.local with your DNS/TLS config in real deployments.
