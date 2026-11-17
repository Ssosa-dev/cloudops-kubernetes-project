# End-to-End CloudOps & DevSecOps Kubernetes Platform on AWS EKS

A production-style, security-hardened microservice deployment pipeline built with **FastAPI**, **Docker**, **Terraform**, **Amazon EKS**, **GitHub Actions (OIDC)**, **Trivy**, and **GitHub Copilot**. This project demonstrates zero-trust CI/CD automation, infrastructure-as-code (IaC) provisioning, container hardening, Horizontal Pod Autoscaling (HPA), and strict FinOps teardown discipline.

---

## Architecture & CI/CD Pipeline

```text
Developer PR / Push to main
        │
        ▼
┌─────────────────────────────────────────────────────────────┐
│ GitHub Actions — CI & DevSecOps Quality Gates (ci.yml)      │
│  ├─ Ruff Linting & Import Sorting + Pytest Unit Suite       │
│  ├─ Terraform Format (fmt -check) & Validate                │
│  └─ Trivy IaC Misconfiguration & Container Image CVE Scan   │
└─────────────────────────────────────────────────────────────┘
        │ (Merge to main)
        ▼
┌─────────────────────────────────────────────────────────────┐
│ GitHub Actions — Continuous Deployment (cd.yml)             │
│  ├─ Short-Lived AWS Credentials via GitHub OIDC (No Keys)   │
│  ├─ Build & Push Immutable SHA Tag to Private Amazon ECR    │
│  └─ Rolling Update & HPA Rollout to Amazon EKS              │
└─────────────────────────────────────────────────────────────┘
        │
        ▼
┌─────────────────────────────────────────────────────────────┐
│ AWS Infrastructure (Provisioned via Terraform)              │
│  ├─ Amazon EKS (cloudops-k8s-eks) + VPC CNI Prefix Deleg.   │
│  ├─ Non-Root Pods (UID 1000, Read-Only Root FS) + /healthz  │
│  └─ Metrics Server + HorizontalPodAutoscaler (2–5 Replicas) │
└─────────────────────────────────────────────────────────────┘
```

---

## Core Engineering Highlights

| Domain | Implementation Details |
| :--- | :--- |
| **Application & Probes** | Python 3.11 + FastAPI (`app/app.py`) exposing `/` metadata and `/healthz` readiness/liveness probes, validated with deterministic `pytest` + `httpx` unit tests. |
| **Infrastructure as Code** | Modular Terraform (`terraform-config/`) provisioning a VPC, Amazon EKS cluster (`cloudops-k8s-eks`), EKS Access Entries, private ECR repository (`image_tag_mutability = "IMMUTABLE"`), and GitHub OIDC IAM roles. |
| **Zero-Secret CI/CD** | GitHub Actions authenticates to AWS via OpenID Connect (`aws-actions/configure-aws-credentials`)—eliminating long-lived static `AWS_ACCESS_KEY_ID` secrets. |
| **DevSecOps & Hardening** | Hardened non-root container (`UID 1000`), Kubernetes `securityContext` (`runAsNonRoot: true`, `readOnlyRootFilesystem: true`, `capabilities.drop: ["ALL"]`), and blocking **Trivy** IaC + image scans on every PR. |
| **Autoscaling & Observability** | Kubernetes Metrics Server + `HorizontalPodAutoscaler` (`autoscaling/v2`) scaling `cloudops-api` between 2 and 5 replicas at 50% target CPU utilization