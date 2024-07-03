variable "prefix" {
  default = "cybernetics" # cybernetics
}

variable "env" {
  default = "test"
}

# Add item lambda function
module "get_exchange_rate" {
  source        = "terraform-aws-modules/lambda/aws"
  function_name = "${var.prefix}-get-exchange-rate-${var.env}"
  handler       = "get-exchange-rates.handler"
  description   = "Lambda function to get-exchange-rates"
  runtime       = "python3.12"
  source_path   = "../backend/src/get-exchange-rates/"
  # store_on_s3   = true
  # s3_bucket     = "cybernetics-code-base"

  # Policy
  attach_policy_json = true
  policy_json = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:Scan",
          "dynamodb:GetItem",
        ],
        "Resource" : [
          "${var.exchange_rate_table_arn}"
        ]
      }
    ]
  })

}

module "update_exchange_rate" {
  source        = "terraform-aws-modules/lambda/aws"
  function_name = "${var.prefix}-update-exchange-rate-${var.env}"
  handler       = "update-exchange-rates.handler"
  description   = "Lambda function to update exchange-rate"
  runtime       = "python3.12"
  source_path   = "../backend/src/update-exchange-rates/"

  # Policy
  attach_policy_json = true
  policy_json = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:PutItem"
        ],
        "Resource" : [
          "${var.exchange_rate_table_arn}"
        ]
      }
    ]
  })
}

module "get_all_exchange_rates" {
  source        = "terraform-aws-modules/lambda/aws"
  function_name = "${var.prefix}-get-all-exchange-rate-${var.env}"
  handler       = "get-all-exchange-rates.handler"
  description   = "Lambda function to update exchange-rate"
  runtime       = "python3.12"
  source_path   = "../backend/src/get-all-exchange-rates/"

  # Policy
  attach_policy_json = true
  policy_json = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:Scan",
          "dynamodb:GetItem",
        ],
        "Resource" : [
          "${var.exchange_rate_table_arn}"
        ]
      }
    ]
  })
}