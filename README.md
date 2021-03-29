# locust-on-aci
Load testing with Locust using Azure Container Instances (ACI)

## Locust deployment via Terraform

This repository contains two Terraform definitions to deploy Locust:

* [headless](./src/headless/infra) - fully automated without a webui
* [webui](./src/testing/infra) - partially automated with a webui

## Locust deployment pipelines

### Headless

The "headless" workflow asks upfront for all required information to conduct the load test:

* Number of Locust worker nodes
* Duration in minutes
* The rate per second in which users are spawned
* Number of concurrent Locust users
* Locust target URL

The workflow will then, based on your selection, deploy the required infrastructure in Azure, conduct the load test as defined, store the results in it's Azure Storage Account and scale down the infrastructure back to 0 - except its Storage Account.

### WebUI

The "webui" workflow spins up a full Locust deployment with the selected number of worker nodes. You can run the same pipeline again to scale the infrastructure down.
