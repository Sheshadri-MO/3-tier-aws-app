#  DevOps 3-Tier AWS Architecture Project

## Overview

This project demonstrates a **production-like 3-tier architecture** deployed on AWS using **Terraform** for infrastructure provisioning and **Ansible** for configuration management.

It includes a load-balanced Node.js application with database integration, caching, and monitoring.

---

##  Architecture

```
User → ALB → EC2 (Node.js App) → MySQL
                                ↓
                              Redis
                                ↓
                        Prometheus + Grafana
```

---

##  Tech Stack

* AWS (EC2, ALB, Security Groups)
* Terraform (Infrastructure as Code)
* Ansible (Configuration Management)
* Node.js (Backend Application)
* MySQL (Database)
* Redis (Caching)
* Prometheus (Monitoring)
* Grafana (Visualization)

---

## Features

*  Load balancing using AWS ALB
*  Multi-node Node.js application
*  Login system with MySQL authentication
*  Redis integration (caching layer)
*  Infrastructure automation with Terraform
*  Configuration automation with Ansible
*  Monitoring with Prometheus & Grafana

---

##  Deployment Steps

###  Provision Infrastructure

```bash
terraform init
terraform apply
```

---

### Configure Servers

```bash
cd ansible
ansible-playbook site.yml
```

---

### Access Application

* 🌐 **ALB URL**
  http://devops-alb-1002074806.eu-north-1.elb.amazonaws.com

* 📊 **Node-exporter**
  http://<monitoring_ip >:9100
  
* 📊 **Prometheus Dashboard**
  http://<monitoring_ip >:9090

* 📊 **Grafana Dashboard**
  http://<monitoring_ip >:3000

---

##  Default Login

```
Username: admin
Password: admin123
```

---

## Monitoring

* Prometheus collects metrics from all servers using Node Exporter
* Grafana provides visualization dashboards
* Real-time monitoring of CPU, memory, and system metrics

---

## Key Learnings

* Implemented a scalable 3-tier architecture
* Debugged real-world issues (502 errors, DB connectivity, SSH issues)
* Automated infrastructure and configuration
* Integrated monitoring and observability

---

## Project Structure

```
aws_ops/
│── terraform/
│── ansible/
│   ├── inventory.ini
│   ├── site.yml
│   └── roles/
│       ├── web/
│       ├── mysql/
│       ├── redis/
│       └── monitor/
```






