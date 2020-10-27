############
# providers #
###########
terraform {
  required_version = ">=0.13"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.31.1"
    }
    datadog = {
      source = "terraform-providers/datadog"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

  provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}

# Create a new datadog monitor
resource "datadog_monitor" "virtualmachine_cpu_usage" {
  name               = "Bytes received on host0"
  type               = "metric alert"
  message            ="Test to create metric alert for a VM" 
 
  query = "avg(last_1h):sum:system.net.bytes_rcvd{host:host0} > 100"

  thresholds = {
            critical = 100
            warning  =80
            critical_recovery = 70
            warning_recovery = 50

  }
  evaluation_delay    = var.evaluation_delay
  new_host_delay      = var.new_host_delay
  notify_no_data      = false
  renotify_interval   = 0
  notify_audit        = false
  timeout_h           = 0
  include_tags        = true
  locked              = false
  require_full_window = false

  tags = concat(["env:${var.environment}", "type:cloud", "provider:azure", "resource:virtualmachine", "created-by:terraform"], var.cpu_usage_extra_tags)

  lifecycle {
    ignore_changes = [silenced]
  }
}
