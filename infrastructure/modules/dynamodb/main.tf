variable "prefix" {
  default = "cybernetics"
}

variable "env" {
  default = "test"
}

module "exchange_rates_table" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  name     = "exchange-rates"
  hash_key = "id"

  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]
}