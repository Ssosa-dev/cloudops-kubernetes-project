# CloudOps Kubernetes Project — GitHub Copilot Engineering Standards

## Architecture & Stack
- **API:** Python 3.11 + FastAPI (`app/app.py`), tested with `pytest` and `httpx` (`app/test_app.py`), linted with `ruff`.
- **Infrastructure:** Terraform (`terraform-config/`) provisioning Amazon EKS (`cloudops-k8s-eks`), private ECR (`cloudops-k8s-api`), and GitHub OIDC authentication.
- **Kubernetes:** Manifests in `k8s/` targeting rolling zero-downtime deployments.

## Mandatory Security & FinOps Guardrails
1. **Container Hardening:** All Dockerfiles must run as non-root (`UID 1000`, `appuser`), install dependencies with `--no-cache-dir`, and avoid storing secrets or credentials.
2. **Kubernetes SecurityContext:** All pods and containers in `k8s/` must enforce `runAsNonRoot: true`, `allowPrivilegeEscalation: false`, `readOnlyRootFilesystem: true`, and `capabilities.drop: ["ALL"]`.
3. **ECR & Supply Chain:** Keep `image_tag_mutability = "IMMUTABLE"` in Terraform and tag images with `${{ github.sha }}` rather than `:latest`.
4. **FinOps Cost Discipline:** Do not introduce NAT Gateways, multi-AZ managed node groups, or persistent KMS keys unless explicitly requested; all AWS resources must tear down cleanly via `terraform destroy`.
5. **Code Quality:** Maintain Ruff import sorting (`I001`) and write deterministic `pytest` unit tests for every new FastAPI route.