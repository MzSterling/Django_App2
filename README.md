📄 README.md
# 🚀 Media Analytics Django App

This project deploys a containerized Django application to **AWS ECS Fargate** behind an **Application Load Balancer (ALB)**.

Infrastructure is managed using **Terraform**.  
Docker images are built automatically using **GitHub Actions** and pushed to **Amazon ECR**.

Terraform deployment is performed manually from your local machine.

---

# 🏗 AWS Architecture Overview

## Core AWS Services Used

- **VPC** (10.0.0.0/16)
- **2 Public Subnets (Multi-AZ)**
- **Internet Gateway**
- **Application Load Balancer (ALB)**
- **Target Group (Port 8000)**
- **ECS Cluster (Fargate launch type)**
- **ECS Service (2 tasks running)**
- **Amazon ECR (Docker image repository)**
- **Security Groups**

---

## 🔁 Request Flow



User Browser
↓
Application Load Balancer (HTTP :80)
↓
Target Group (HTTP :8000)
↓
ECS Fargate Tasks (Django + Gunicorn)
↓
Docker Image from Amazon ECR


---

# 🐳 Docker Configuration

The Docker container:

- Installs dependencies from `requirements.txt`
- Collects static files
- Runs migrations automatically
- Starts Gunicorn on port 8000

Container startup command:
python manage.py migrate && gunicorn backend.wsgi:application --bind 0.0.0.0:8000


---

## ❤️ Health Check Endpoint

The application exposes:

/health/


Returns:
Media Analytics App is Running

Used by:
- ECS container health check
- ALB target group health check

---

# 🔁 CI/CD Pipeline (GitHub Actions)

Location:
.github/workflows/cicd.yml

## What Happens on Every Push to `main`
1. GitHub checks out the repository
2. AWS credentials are configured
3. Logs into Amazon ECR
4. Builds Docker image
5. Tags image as `latest`
6. Pushes image to ECR

⚠️ Terraform is NOT executed in CI.
Infrastructure deployment is manual.

---

## 🔐 Required GitHub Secrets

In GitHub:

**Settings → Secrets and variables → Actions**

Add:

AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_ACCOUNT_ID


---

# 🚀 Deployment Instructions


## Step 1 — Deploy Infrastructure (Manual)

Initialize Terraform:


terraform init


Review execution plan:



terraform plan


Apply infrastructure:



terraform apply


Get ALB DNS:



terraform output alb_dns


---

## Step 2 — Push Code

Push to the `main` branch:

git push origin main

GitHub Actions will:
- Build Docker image
- Push image to ECR

You do NOT need to build Docker locally.

---


## Step 3 — Access the Application

Open in browser:



http://<alb_dns>/


Health check:



http://<alb_dns>/health/


---

# 📁 Project Structure



.
├── backend/
│ ├── settings.py
│ ├── urls.py
│ └── wsgi.py
├── Dockerfile
├── requirements.txt
├── main.tf
├── networking.tf
├── ecs.tf
├── alb.tf
├── security_groups.tf
├── variables.tf
├── outputs.tf
└── .github/workflows/cicd.yml


---

# 🔐 Security Configuration

### ALB Security Group
- Allows inbound HTTP (Port 80) from 0.0.0.0/0

### ECS Security Group
- Allows inbound Port 8000 only from ALB

---

# 🌍 Networking Design

- ECS tasks run in **public subnets**
- `assign_public_ip = true`
- No NAT Gateway required
- ALB routes traffic to ECS tasks via Target Group

---

# 🧹 Destroy Infrastructure

To delete all AWS resources:



terraform destroy


---

# 🎯 Future Improvements

- Add HTTPS (ACM + ALB listener 443)
- Move ECS tasks to private subnets with NAT
- Add RDS PostgreSQL
- Store Terraform state in S3 backend
- Use versioned Docker image tags instead of `latest`
- Add Route53 custom domain

---

# 🛠 Technologies Used

- Django
- Docker
- AWS ECS (Fargate)
- Amazon ECR
- Application Load Balancer
- Terraform
- GitHub Actions

---

# 📌 Summary

✔ Docker image automatically built in GitHub  
✔ Image pushed to ECR  
✔ Infrastructure deployed via Terraform  
✔ ECS Fargate runs Django behind ALB  
✔ Health checks configured correctly  
✔ No manual container builds required  

---

## 👨‍💻 Author:MzSterling

Deployed using Infrastructure as Code and modern CI/CD best practices.
