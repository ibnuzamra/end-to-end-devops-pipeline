# Enterprise End-to-End DevOps CI/CD & GitOps Project

[![IaC: Terraform](https://img.shields.io/badge/IaC-Terraform_1.5+-623CE4?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![GitOps: Atlantis](https://img.shields.io/badge/GitOps-Atlantis_v0.46-2D72D9?logo=terraform&logoColor=white)](https://www.runatlantis.io/)
[![CI/CD: GitLab CI](https://img.shields.io/badge/CI%2FCD-GitLab_CI-FC6D26?logo=gitlab&logoColor=white)](https://about.gitlab.com/)
[![Security: Trivy & Inspector](https://img.shields.io/badge/Security-Trivy_%7C_AWS_Inspector-FF9900?logo=amazon-aws&logoColor=white)](https://aws.amazon.com/inspector/)
[![GitOps: ArgoCD](https://img.shields.io/badge/Delivery-ArgoCD_%7C_OpenShift_GitOps-EF7B42?logo=argo&logoColor=white)](https://argo-cd.readthedocs.io/)
[![Packaging: Helm](https://img.shields.io/badge/Packaging-Helm_3-0F1689?logo=helm&logoColor=white)](https://helm.sh/)

Enterprise-grade end-to-end DevOps delivery pipeline and cloud infrastructure automation for microservices, featuring **Atlantis-driven Terraform IaC**, **GitLab CI with dual-layer container vulnerability scanning**, and **ArgoCD (OpenShift GitOps) with Kargo multi-environment continuous deployment**.

> **Note:** All application identifiers, private registries, internal domains, and AWS account credentials in this repository have been sanitized into standard placeholders (`project`, `project-repository`, `registry.internal.corp`) for public portfolio representation.

---

## Project Overview

This project is an enterprise-grade end-to-end DevOps project that demonstrates Infrastructure as Code (IaC), CI/CD automation, container security scanning, Kubernetes/OpenShift orchestration, and GitOps delivery on AWS.

> 📖 **In-Depth Technical Documentation:** For deep-dive architectural breakdown, Kargo multi-environment promotion manifests, and resume bullets, see [project-devops-pipeline.md](./project-devops-pipeline.md).

The project provisions AWS infrastructure using Terraform and Atlantis, builds, tests, and security-scans application changes through GitLab CI, stores container images in Amazon ECR, deploys microservices to Kubernetes / Red Hat OpenShift, and manages continuous deployment using ArgoCD and Kargo.

---

## Architecture

Terraform + Atlantis → AWS Infrastructure → GitLab CI/CD → Docker → AWS Inspector & Aqua Trivy → Amazon ECR → ArgoCD + Kargo → Kubernetes / OpenShift

---

## Technologies Used

### Infrastructure as Code
- Terraform
- Atlantis
- AWS VPC
- AWS EKS
- AWS EC2
- AWS IAM
- AWS Route53
- Amazon S3 (Remote State)
- Amazon DynamoDB (State Locking)

### CI/CD
- GitLab CI
- GitLab Runner

### Containerization & Registry
- Docker
- Amazon ECR
- Helm

### Kubernetes & Container Platform
- Amazon EKS
- Red Hat OpenShift
- Kubernetes Deployments & Services
- Multi-Source Helm Applications

### GitOps & Delivery
- ArgoCD (OpenShift GitOps)
- Kargo (Automated Multi-Stage Promotion)

### Security & Quality Checks
- SonarQube (SAST & Code Quality)
- Aqua Trivy (Vulnerabilities & Secret Scanning)
- AWS Inspector2 (Container Image CVE Scanning)
- pnpm / Node.js & Golang (Automated Polyglot Unit Testing)

---

## Project Structure

```text
end-to-end-devops-pipeline/
│
├── terraform/        # AWS infrastructure provisioning with Atlantis
│   ├── atlantis.yaml # Atlantis GitOps policy and multi-project configuration
│   ├── env/          # Root modules separated by environment (dev, uat, prod)
│   ├── iam/          # Least-privilege IAM policy documents
│   └── modules/      # Reusable modules
│       ├── vpc/      # Multi-AZ VPC, public/private subnets, IGW, & NAT GW
│       ├── ec2/      # EC2 compute instances & security groups
│       ├── eks/      # Amazon EKS cluster & managed node groups
│       ├── iam_ecr_inspector/ # ECR & AWS Inspector IAM policies
│       └── route53/  # Route53 DNS hosted zones & records
│
├── gitlab-ci/        # 6-stage GitLab CI/CD pipeline & container build
│   ├── .gitlab-ci.yml# Complete CI/CD configuration
│   ├── Dockerfile    # Multi-stage production container build
│   └── .dockerignore
│
├── gitops/           # GitOps delivery manifests
│   ├── argocd/       # ArgoCD Application manifests (Multi-source pattern)
│   ├── values/       # Environment-specific Helm values (dev, uat, prod)
│   └── kargo/        # Kargo multi-environment automated stage promotion
│
└── README.md
```

---

## CI/CD Pipeline Flow

1. Developer pushes commit or creates Merge Request in GitLab.
2. Source code checkout and dependency installation with frozen lockfile.
3. Automated polyglot unit testing with Node.js (pnpm) and Golang.
4. Static Application Security Testing (SAST) via SonarQube.
5. Docker image build with isolated temporary scan tag (`scan-${CI_PIPELINE_ID}-${CI_JOB_ID}`).
6. Cloud vulnerability analysis via AWS Inspector2 API on Amazon ECR digest.
7. Local container security and secret scanning with Aqua Trivy.
8. Manual review and approval gate for release promotion.
9. Promotion of verified image to immutable semantic release tag (`dev-*`, `uat-*`, `prod-*`).
10. Automatic purge of temporary scan image from Amazon ECR.
11. Kargo detects new ECR image freight and commits updated `values.yaml` in Git.
12. ArgoCD automatically synchronizes the desired state to Kubernetes / OpenShift with self-healing.

---

## Infrastructure Provisioning

Terraform and Atlantis provision:

- Modular Multi-AZ VPC (`172.16.72.0/22`) across Availability Zones (`ap-southeast-3a`, `ap-southeast-3b`)
- Public Subnets (`172.16.72.0/26`, `172.16.72.64/26`) with Internet Gateway (IGW) and ELB tags
- Private Application Subnets (`172.16.74.0/26`, `172.16.74.64/26`) with dedicated NAT Gateway routing
- Independent Route Tables, EIPs, and Subnet Associations
- Amazon EKS Cluster & Managed Node Groups
- EC2 Instances & Security Groups
- AWS Route53 DNS Hosted Zones & Records
- AWS IAM Roles (ECR push/pull, AWS Inspector scanning, IRSA)
- Amazon S3 Bucket (AES256-encrypted remote state with versioning)
- Amazon DynamoDB Table (`terraform-lock` distributed concurrency lock)
- Atlantis Server & Webhook Integration for Merge Request automation

---

## Kubernetes & GitOps Delivery

### ArgoCD Application (Multi-Source Pattern)

- **Source 1 (OCI Registry):** Base Helm Chart hosted in internal OCI Registry.
- **Source 2 (Git Repository):** Environment-specific configuration (`values.yaml`) in Git.
- **Automated Sync Policy:** `automated.prune = true` and `automated.selfHeal = true` to eliminate configuration drift.
- **Namespace Management:** Automated namespace provisioning with `CreateNamespace=true`.

### Kargo Multi-Stage Promotion

- Continuous freight tracking from Amazon ECR release tags.
- Declarative stage promotion across Development, UAT, and Production.
- Automated Git commit and push of promoted image tags into the GitOps repository.

---

## Security & Validation Stages

The pipeline enforces multiple quality and security gates before deployment:

### Unit Testing

```bash
pnpm install --frozen-lockfile
pnpm test
```

### SonarQube SAST

```bash
sonar-scanner -Dsonar.projectKey=project -Dsonar.sources=.
```

### Aqua Trivy (Vulnerabilities & Secrets)

```bash
docker run --rm \
  -v trivy-cache:/root/.cache/ \
  aquasec/trivy:latest image \
  --scanners vuln,secret \
  --exit-code 1 \
  --severity HIGH,CRITICAL \
  "${SCAN_IMAGE}"
```

### AWS Inspector2 CVE Query

```bash
aws inspector2 list-findings \
  --filter-criteria "{\"ecrImageHash\":[{\"comparison\":\"EQUALS\",\"value\":\"${IMAGE_DIGEST}\"}]}"
```

### Terraform Atlantis GitOps Plan

```text
# Inside GitLab Merge Request comments:
atlantis plan -p prod
atlantis apply -p prod
```

---

## Results

✅ Modular AWS VPC (`172.16.72.0/22`) provisioned with multi-AZ public/private subnets, IGW, and NAT Gateways

✅ Modular AWS infrastructure provisioned with Terraform and DynamoDB state locking

✅ GitOps-driven IaC plan & apply approval workflow automated with Atlantis

✅ Enterprise 6-stage CI/CD pipeline automated with GitLab CI

✅ Dual-layer container security scanning with AWS Inspector and Aqua Trivy

✅ Docker images securely stored, tagged, and promoted in Amazon ECR

✅ Declarative GitOps deployment managed by ArgoCD with self-healing and drift detection

✅ Multi-environment continuous delivery automated with Kargo stage promotion

---

## Author

Ibnu Zamratul Iman

DevOps Engineer

GitHub:
https://github.com/ibnuzamra
LinkedIn:
https://linkedin.com/in/ibnuzamra

