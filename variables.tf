# Basics
variable "subscription_id"{
  description = "Subscription ID"
  type        = string
}

variable "service_name" {
    type    = string
}

variable "environment" {
    type    = string
    default  = "dev"
}

variable "datadog_api_key" {
    type    = string
}

variable "datadog_app_key" {
    type    = string
}

variable "cpu_usage_time_aggregator" {
  description = "Monitor aggregator for Virtual Machine CPU [available values: min, max or avg]"
  type        = string
  default     = "min"
}

variable "cpu_usage_timeframe" {
  description = "Monitor timeframe for Virtual Machine CPU [available values: `last_#m` (1, 5, 10, 15, or 30), `last_#h` (1, 2, or 4), or `last_1d`]"
  type        = string
  default     = "last_15m"
}

variable "cpu_usage_threshold_critical" {
  description = "Virtual Machine CPU usage in percent (critical threshold)"
  default     = "90"
}

variable "cpu_usage_threshold_warning" {
  description = "Virtual Machine CPU usage in percent (warning threshold)"
  default     = "80"
}
