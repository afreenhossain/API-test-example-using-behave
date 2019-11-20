Feature: API endpoint to send user's bank details

  Scenario Outline: A user wants to create a record with "<case>"
    Given A user makes a request to the endpoint "bank"
      And with headers
          """
          {
            "Cache-Control": "no-cache",
            "Content-Type": "application/json"
          }
          """
      And with payment method "<payment_method>"
      And with bank country code "<bank_country_code>"
      And with account name "<account_name>"
      And with account number "<account_number>"
      And with swift code "<swift_code>"
      And with bsb code "<bsb>"
      And with aba "<aba>"
    When The user sends a post request
    Then The user receives a status code of "<status_code>"
      And The user receives a response body of <response_body>

    Examples: bank data
      | case                                               | payment_method | bank_country_code | account_name | account_number        | swift_code | aba        | bsb     | status_code | response_body                                                                                   |
      | Missing payment_method                             |                | US                | John Smith   | 123                   | ICBCUSBJ   | 11122233A  |         | 400         | {"error": "'payment_method' field required, the value should be either 'LOCAL' or 'SWIFT'"}     |
      | Missing bank_country_code                          | SWIFT          |                   | John Smith   | 123                   | ICBCUSBJ   | 11122233A  |         | 400         | {"error": "'bank_country_code' is required, and should be one of 'US', 'AU', or 'CN'"}          |
      | Wrong bank_country_code                            | SWIFT          | EN                | John Smith   | 123                   | ICBCUSBJ   | 11122233A  |         | 400         | {"error": "'bank_country_code' is required, and should be one of 'US', 'AU', or 'CN'"}          |
      | Missing account_name                               | SWIFT          | US                |              | 123                   | ICBCUSBJ   | 11122233A  |         | 400         | {"error": "'account_name' is required"}                                                         |
      | Missing account_number                             | SWIFT          | US                | John Smith   |                       | ICBCUSBJ   | 11122233A  |         | 400         | {"error": "'account_number' is required"}                                                       |
      | swift_code missing when payment method is SWIFT    | SWIFT          | US                | John Smith   | 123                   |            | 11122233A  |         | 400         | {"error": "'swift_code' is required when payment method is 'SWIFT'"}                            |
      | bsb missing when bank country is AU                | SWIFT          | AU                | John Smith   | 123456                | ICBCAUBJ   | 11122233A  |         | 400         | {"error": "'bsb' is required when bank country code is 'AU'"}                                   |
      | aba missing when country is US                     | SWIFT          | US                | John Smith   | 123                   | ICBCUSBJ   | null       |         | 400         | {"error": "'aba' is required when bank country code is 'US'"}                                   |
      | account_number length greater than 17 for US       | SWIFT          | US                | John Smith   | 123456789101112131    | ICBCUSBJ   | 11122233A  |         | 400         | {"error": "Length of account_number should be between 7 and 11 when bank_country_code is 'US'"} |
      | account_number length less than 6 for AU           | LOCAL          | AU                | John Smith   | 12345                 | ICBCUSBJ   | 11122233A  | 123456  | 400         | {"error": "Length of account_number should be between 7 and 11 when bank_country_code is 'US'"} |
      | account_number length greater than 9 for AU        | LOCAL          | AU                | John Smith   | 1234567891            | ICBCUSBJ   | 11122233A  | 123456  | 400         | {"error": "Length of account_number should be between 7 and 11 when bank_country_code is 'US'"} |
      | account_number length less than 8 for CN           | LOCAL          | CN                | John Smith   | 1234567               | ICBCUSBJ   | 11122233A  |         | 400         | {"error": "Length of account_number should be between 7 and 11 when bank_country_code is 'US'"} |
      | account_number length greater than 20 for CN       | LOCAL          | CN                | John Smith   | 123456789101112131415 | ICBCUSBJ   | 11122233A  |         | 400         | {"error": "Length of account_number should be between 7 and 11 when bank_country_code is 'US'"} |
      | account_number length is 1 for US                  | SWIFT          | US                | John Smith   | 1                     | ICBCUSBJ   | 11122233A  |         | 200         | {"success":"Bank details saved"}                                                                |
      | account_number length is 17 for US                 | SWIFT          | US                | John Smith   | 11111111111111111     | ICBCUSBJ   | 11122233A  |         | 200         | {"success":"Bank details saved"}                                                                |
      | account_number length is 6 for AU                  | LOCAL          | AU                | John Smith   | 123456                | ICBCUSBJ   | 11122233A  | 123456  | 200         | {"success":"Bank details saved"}                                                                |
      | account_number length is 9 for AU                  | LOCAL          | AU                | John Smith   | 123456789             | ICBCUSBJ   | 11122233A  | 123456  | 200         | {"success":"Bank details saved"}                                                                |
      | account_number length is 8 for CN                  | LOCAL          | CN                | John Smith   | 12345678              | ICBCUSBJ   | 11122233A  |         | 200         | {"success":"Bank details saved"}                                                                |
      | account_number length is 20 for CN                 | LOCAL          | CN                | John Smith   | 12345678910111213141  | ICBCUSBJ   | 11122233A  |         | 200         | {"success":"Bank details saved"}                                                                |
      | 5th and 6th char of swift code matches AU          | SWIFT          | AU                | John Smith   | 1234567               | ICBCAUBJ   | 11122233A  | 123456  | 200         | {"success":"Bank details saved"}                                                                |
      | 5th and 6th char of swift code matches CN          | SWIFT          | CN                | John Smith   | 12345678              | ICBCCNBJ   | 11122233A  |         | 200         | {"success":"Bank details saved"}                                                                |
      | 5th and 6th char of swift code matches US          | SWIFT          | US                | John Smith   | 123                   | ICBCUSBJ   | 11122233A  |         | 200         | {"success":"Bank details saved"}                                                                |
      | 5th and 6th char of swift code doesn't match AU    | SWIFT          | AU                | John Smith   | 1234567               | ICBCUSBJ   | 11122233A  | 123456  | 400         | {"error":"The swift code is not valid for the given bank country code: AU"}                     |
      | 5th and 6th char of swift code doesn't match CN    | SWIFT          | CN                | John Smith   | 1234567               | ICBCUSBJ   | 11122233A  |         | 400         | {"error":"The swift code is not valid for the given bank country code: CN"}                     |
      | 5th and 6th char of swift code doesn't match US    | SWIFT          | US                | John Smith   | 123                   | ICBCCNBJ   | 11122233A  |         | 400         | {"error":"The swift code is not valid for the given bank country code: US"}                     |
      | bsb less than 6 char for AU                        | LOCAL          | AU                | John Smith   | 123456                | ICBCCNBJ   | 11122233A  | 12345   | 400         | {"error":"Length of 'bsb' should be 6"}                                                         |
      | bsb greater than 6 char for AU                     | LOCAL          | AU                | John Smith   | 123456                | ICBCCNBJ   | 11122233A  | 1234567 | 400         | {"error":"Length of 'bsb' should be 6"}                                                         |
      | All valid for AU with bsb with 6 chars             | LOCAL          | AU                | John Smith   | 123456                | ICBCUSBJ   | 11122233A  | 123456  | 200         | {"success":"Bank details saved"}                                                                |
      | aba less than 9 char for US                        | LOCAL          | US                | John Smith   | 123456                | ICBCCNBJ   | 12345678   | 1234567 | 400         | {"error":"Length of 'aba' should be 9"}                                                         |
      | aba greater than 9 char for US                     | LOCAL          | US                | John Smith   | 123456                | ICBCCNBJ   | 1234567891 | 1234567 | 400         | {"error":"Length of 'aba' should be 9"}                                                         |
      | All valid for US with 9 char aba                   | SWIFT          | US                | John Smith   | 123                   | ICBCUSBJ   | 11122233A  |         | 200         | {"success":"Bank details saved"}                                                                |
      | Account name is equal to 2                         | SWIFT          | US                | 12           | 123                   | ICBCUSBJ   | 11122233A  |         | 200         | {"success":"Bank details saved"}                                                                |
      | Account name is equal to 10                        | SWIFT          | US                | 1234567890   | 123                   | ICBCUSBJ   | 11122233A  |         | 200         | {"success":"Bank details saved"}                                                                |
      | Account name length less than 2                    | SWIFT          | US                | 1            | 123                   | ICBCUSBJ   | 11122233A  |         | 400         | {"error":"Length of account_name should be between 2 and 10"}                                   |
      | Account name length greater than 10                | SWIFT          | US                | 12345678910  | 123                   | ICBCUSBJ   | 11122233A  |         | 400         | {"error":"Length of account_name should be between 2 and 10"}                                   |
      | Account name using random characters               | SWIFT          | US                | !@#$%^&*()   | 123                   | ICBCUSBJ   | 11122233A  |         | 200         | {"success":"Bank details saved"}                                                                |
      | Account name using more random characters          | SWIFT          | US                | -_=+\|]}10   | 123                   | ICBCUSBJ   | 11122233A  |         | 200         | {"success":"Bank details saved"}                                                                |
      | Account name using more random characters          | SWIFT          | US                | [{'";:/?.>   | 123                   | ICBCUSBJ   | 11122233A  |         | 200         | {"success":"Bank details saved"}                                                                |
      | Account name using more random characters          | SWIFT          | US                | ,<10Az` ~    | 123                   | ICBCUSBJ   | 11122233A  |         | 200         | {"success":"Bank details saved"}                                                                |
      | Account number using random characters             | SWIFT          | US                | John Smith   | !@#$%^&*()-_=+\~`     | ICBCUSBJ   | 11122233A  |         | 200         | {"success":"Bank details saved"}                                                                |
      | Account number using random characters             | SWIFT          | US                | John Smith   | ]}[{'";:/?.>, <aZ     | ICBCUSBJ   | 11122233A  |         | 200         | {"success":"Bank details saved"}                                                                |
