# Technical Documentation: Terraform Google Compute Engine

## 1. Overview

This Terraform configuration is designed to provision a single Google Compute Engine (GCE) virtual machine instance. The instance is a low-cost, small-scale machine ideal for development, testing, or running lightweight applications.

The configuration defines the necessary provider, the virtual machine resource itself, and an output to display the public IP address of the instance upon creation.

## 2. Requirements

- **Terraform:** Version `1.0.0` or newer.
- **Google Cloud Provider:** Version `~> 4.0`.

## 3. Provider Configuration

The configuration uses the `hashicorp/google` provider to interact with Google Cloud Platform APIs.

- **Project:** `fp-secure-api-gateway`
- **Region:** `asia-southeast2` (Jakarta)
- **Zone:** `asia-southeast2-a`

## 4. Resources

This configuration provisions the following resource:

### Google Compute Instance (`google_compute_instance.e2_micro`)

- **Instance Name:** `e2-micro-instance`
- **Machine Type:** `e2-micro` (2 vCPUs, 1 GB memory)
- **Zone:** `asia-southeast2-a`

#### Boot Disk
- **Image:** Debian 11 (`debian-cloud/debian-11`)
- **Disk Type:** Standard Persistent Disk (`pd-standard`)
- **Size:** 10 GB

#### Network
- **Network:** `default` VPC network.
- **IP Address:** The instance is configured with an ephemeral public IP address, allowing it to be accessed from the internet.

## 5. Outputs

- **`instance_ip`**: After the `terraform apply` command is successfully executed, this output will display the public IP address assigned to the `e2-micro-instance`.

## 6. How to Use

1.  **Initialize Terraform:**
    Open a terminal in the `compute-engine` directory and run the following command to initialize the Terraform workspace and download the required provider.
    ```bash
    terraform init
    ```

2.  **Plan the Deployment:**
    Run this command to see an execution plan. This will show you what resources Terraform will create, modify, or destroy.
    ```bash
    terraform plan
    ```

3.  **Apply the Configuration:**
    Execute this command to create the resources defined in the configuration. You will be prompted to confirm the action.
    ```bash
    terraform apply
    ```

4.  **Destroy Resources:**
    When you no longer need the resources, you can destroy them to avoid incurring further costs.
    ```bash
    terraform destroy
    ```
