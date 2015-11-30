# Created by Florian TEISSEDRE - florian.teissedre@hpe.com

namespace: heroku.test.account

imports:
  heroku_operations: Heroku.content.account.current
  json_operations: Heroku.content.json

flow:
  name: test_update_email_account
  inputs:
    - username
    - password
    - email
  workflow:
    - create_json:
        do:
          json_operations.createSimpleJson:
            - list: "'email:\"' + email + '\"' + '|' + 'password:\"' + password + '\"' "
        publish:
          - json_result: json

    - update_email_account:
        do:
          heroku_operations.updateEmailAccount:
            - username
            - password
            - json_body: json_result
        publish:
          - http_result: return_result
        navigate:
          SUCCESS: analyse_response
          FAILURE: HTTP_ERROR

    - analyse_response:
        do:
          json_operations.analyseJsonResponse:
            - json_response: "http_result"
        publish:
          - returnResult
          - idTypeResult
        navigate:
          SUCCESS: SUCCESS
          UNAUTHORIZED: UNAUTHORIZED
          NOT_FOUND: NOT_FOUND
          INVALID_PARAMS: INVALID_PARAMS
          BAD_REQUEST: BAD_REQUEST
          FAILURE: JSON_ANALYSE_ERROR


  results:
    - SUCCESS : response_type == '0'
    - FAILURE 
    - HTTP_ERROR
    - JSON_ANALYSE_ERROR
    - UNAUTHORIZED
    - NOT_FOUND
    - INVALID_PARAMS
    - BAD_REQUEST