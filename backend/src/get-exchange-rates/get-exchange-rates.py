import boto3
import json

dynamodb_client = boto3.resource('dynamodb')

EXCHANGE_RATES_DB_TABLE_NAME='exchange-rates'
def get_exchange_rates():
    try:
        exchange_rate_table = dynamodb_client.Table(EXCHANGE_RATES_DB_TABLE_NAME)
        res = exchange_rate_table.scan()
        if res['ResponseMetadata']['HTTPStatusCode'] == 200:
            print('Data retreived from DB successfully.')
            data = res['Items']
            return data
        else:
            print('Unable to insert data into DynamoDB {}.'.format(res))
            return []
    except Exception as ex:
        print('Exception Occurred {}'.format(ex))
        return []

def handler(event, context):
    data = get_exchange_rates()
    return {
      'statusCode': 200,
      'body': json.dumps(data),
      'headers': {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET,OPTIONS,POST,PUT,DELETE',
        'Access-Control-Allow-Headers': 'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token,token',
        'Content-Type': 'application/json',
      },
    }