# Invocation ARNS
output "get_exchange_rate_invoke_arn" {
  value       = module.get_exchange_rate.lambda_function_invoke_arn
  description = "Invocation ARN of get_exchange_rate lambda function"
}

output "get_all_exchange_rates_invoke_arn" {
  value       = module.get_all_exchange_rates.lambda_function_invoke_arn
  description = "Invocation ARN of the update exchange rate lambda function"
}

# Function ARNs
output "get_exchange_rate_arn" {
  value       = module.get_exchange_rate.lambda_function_arn
  description = "ARN of get exchange rate lambda function"
}

output "get_all_exchange_rates_arn" {
  value       = module.get_all_exchange_rates.lambda_function_arn
  description = "ARN of update exchange rate lambda function"
}


output "update_exchange_rate_name" {
  value       = module.update_exchange_rate.lambda_function_name
  description = "ARN of get exchange rate lambda function"
}

output "update_exchange_rate_arn" {
  value       = module.update_exchange_rate.lambda_function_arn
  description = "ARN of update exchange rate lambda function"
}
