import csv
import boto3
import requests
from datetime import datetime
from zipfile import ZipFile


dynamodb_client = boto3.resource("dynamodb")

EXCHANGE_RATES_FILE_URL = "https://www.ecb.europa.eu/stats/eurofxref/eurofxref.zip"
ZIP_FILENAME = "/tmp/eurofxref.zip"
EXCHANGE_RATE_FILE = "/tmp/eurofxref.csv"
EXCHANGE_RATES_DB_TABLE_NAME="exchange-rates"

def download_rates_info():
    try:
        zip_file = requests.get(EXCHANGE_RATES_FILE_URL)
        with open(ZIP_FILENAME, mode="wb") as file:
            file.write(zip_file.content)
        print("file downloaded successfully.")
    except Exception as ex:
        print("Error occurred downloading file: {}".format(ex))

def parse_rates():
    try:
        with ZipFile(ZIP_FILENAME,"r") as zip_ref:
            zip_ref.extractall("/tmp/")
            data = []
            with open(EXCHANGE_RATE_FILE, mode='r') as csv_file:
                csv_reader = csv.DictReader(csv_file)
                for row in csv_reader:
                    data = { key.strip(): value.strip() for key, value in row.items() if value != '' }
                    data = {k: v for k, v in data.items() if k}
                    data["id"]=datetime.now().isoformat() # unique id for data
            print("Exchange rates parsed successfully.")
            return data
    except Exception as ex:
        print("Error occurred while parsing exchange rates: {}".format(ex))

def update_db(exchange_rate):
    try:
        exchange_rate_table = dynamodb_client.Table(EXCHANGE_RATES_DB_TABLE_NAME)
        res = exchange_rate_table.put_item(
            Item=exchange_rate
        )
        if res['ResponseMetadata']['HTTPStatusCode'] == 200:
            print("Data Inserted into DB successfully.")
        else:
            print("Unable to insert data into DynamoDB {}.".format(res))
    except Exception as ex:
        print("Exception Occurred {}".format(ex))

def get_exchange_rates():
    download_rates_info()
    current_exchange_rate = parse_rates()
    update_db(current_exchange_rate)

def handler(event, context):
    get_exchange_rates()
    return {
      'statusCode': 200,
      'body': '',
      'headers': {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET,OPTIONS,POST,PUT,DELETE',
        'Access-Control-Allow-Headers': 'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token,token',
        'Content-Type': 'application/json',
      },
    }