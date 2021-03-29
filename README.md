# locust-on-aci
Load testing with Locust using Azure Container Instances (ACI)

## Locust deployment via Terraform

This repository contains two Terraform definitions to deploy Locust:

* [headless](./src/headless/infra) - fully automated without a webui
* [webui](./src/testing/infra) - partially automated with a webui

## Locust deployment pipelines
