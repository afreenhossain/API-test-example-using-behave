
import json

import requests
from assertpy import assert_that
from behave import given, when, then, step

from config import CONFIG


@given('A user makes a request to the endpoint "{endpoint}"')
def set_url(context, endpoint):
    context.endpoint = endpoint


@step('with headers')
def set_headers(context):
    headers = json.loads(context.text)
    context.headers = headers


@step('with payment method "{payment_method}"')
def set_payment_method(context, payment_method):
    context.request_body = {"payment_method": payment_method}


@step('with bank country code "{bank_country_code}"')
def set_bank_country_code(context, bank_country_code):
    context.request_body["bank_country_code"] = bank_country_code


@step('with account name "{account_name}"')
def set_account_name(context, account_name):
    context.request_body["account_name"] = account_name


@step('with account number "{account_number}"')
def set_account_number(context, account_number):
    context.request_body["account_number"] = account_number


@step('with swift code "{swift_code}"')
def set_swift_code(context, swift_code):
    context.request_body["swift_code"] = swift_code


@step('with bsb code "{bsb}"')
def set_aba(context, bsb):
    context.request_body["bsb"] = bsb


@step('with aba "{aba}"')
def set_aba(context, aba):
    context.request_body["aba"] = aba


@when('The user sends a post request')
def execute_post_request(context):
    url = f'{CONFIG.base_url}/{context.endpoint}'
    response = requests.post(url, headers=context.headers, json=context.request_body)
    context.response_body = response.json()
    context.status_code = response.status_code


@then('The user receives a status code of "{status_code}"')
def check_status_code(context, status_code):
    assert_that(str(context.status_code)).is_equal_to(status_code)


@step('The user receives a response body of {response_body}')
def check_response_body(context, response_body):
    assert_that(context.response_body).is_equal_to(json.loads(response_body))

#
# @step('A user creates {country_code} record with account number {acc_number}')
# def create_record(context, country_code, acc_number):
#     context.execute_step(f'''
#     Given A user makes a request to the endpoint "bank"
#       And with headers
#           """
#           {
#             "Cache-Control": "no-cache",
#             "Content-Type": "application/json"
#           }
#           """
#       And with payment method "SWIFT"
#       And with bank country code "{country_code}"
#       And with account name "Julia Roberts"
#       And with account number "{acc_number}"
#       And with swift code "ICBCUSBJ"
#       And with aba "2232"
#     When The user sends a post request
#     ''')
