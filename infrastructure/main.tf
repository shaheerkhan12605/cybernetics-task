# Create dynamoDB tables
module "dynamodb_tables" {
  source = "./modules/dynamodb"
}

# Deploy lambda functions
module "lambda_functions" {
  source                  = "./modules/lambda-functions"
  exchange_rate_table_arn = module.dynamodb_tables.exchange_rate_table_arn
}

module "api_gateway" {
  source = "./modules/api-gateway"

  # Invoke ARNs
  get_exchange_rate_invoke_arn      = module.lambda_functions.get_exchange_rate_invoke_arn
  get_all_exchange_rates_invoke_arn = module.lambda_functions.get_all_exchange_rates_invoke_arn

  # Function ARNs
  get_exchange_rate_arn      = module.lambda_functions.get_exchange_rate_arn
  get_all_exchange_rates_arn = module.lambda_functions.get_all_exchange_rates_arn
}

resource "aws_cloudwatch_event_rule" "update_exchange_rate_lambda_trigger" {
  name                = "update-exchange-rate"
  description         = "Fires every day at 00:00"
  schedule_expression = "rate(5 minutes)" # Kept 5 minutes for testing minute for testing
}

# Trigger our lambda based on the schedule
resource "aws_cloudwatch_event_target" "trigger_lambda_on_schedule" {
  rule      = aws_cloudwatch_event_rule.update_exchange_rate_lambda_trigger.name
  target_id = "lambda_function"
  arn       = module.lambda_functions.update_exchange_rate_arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_invoke_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_functions.update_exchange_rate_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.update_exchange_rate_lambda_trigger.arn
}