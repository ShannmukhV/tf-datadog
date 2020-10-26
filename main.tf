############
# providers #
###########
/*
provider "azurerm" {
  version = ">=2.0.0"
  features {}
  subscription_id = var.subscription_id
}
*/
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
  name               = var.service_name
  type               = "metric alert"
  message            = "Monitor triggered. Notify: ${var.service_name}"
  escalation_message = "Escalation message for ${var.service_name}"

 # query = "avgsystem.load.1{service:${var.service_name}} by {host}"

query = <<EOQ
    ${var.cpu_usage_time_aggregator}(${var.cpu_usage_timeframe}): (
      avg:azure.vm.percentage_cpu by {app-adtest-sandbox-useast2,eastus2,app-adtest-vm}
    ) > ${var.cpu_usage_threshold_critical}
EOQ

/*
  thresholds = {
    ok                = 0
    warning           = 50
    warning_recovery  = 1
    critical          = 80
    critical_recovery = 3
  }
*/
  thresholds = {
    critical = var.cpu_usage_threshold_critical
    warning  = var.cpu_usage_threshold_warning
  }


  notify_no_data    = false
  renotify_interval = 60

  notify_audit = false
  timeout_h    = 60
  include_tags = true

  # ignore any changes in silenced value; using silenced is deprecated in favor of downtimes
  lifecycle {
    ignore_changes = [silenced]
  }

  tags = concat(["service:${var.service_name}", "environment:${var.environment}", "resource:virtualmachine"])
}
