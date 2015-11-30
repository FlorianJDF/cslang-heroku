# Created by Florian TEISSEDRE - florian.teissedre@hpe.com

namespace: io.cloudslang.heroku.domains

imports:
  heroku_operations: io.cloudslang.heroku.domains
  json_operations: io.cloudslang.heroku.json

flow:
  name: test_create_app_domain
  inputs:
    - username
    - password
    - app_name_or_id
    - hostname
  workflow:
    - create_json:
        do:
          json_operations.createSimpleJson:
            - list: "'hostname:\"' + hostname + '\"'"
        publish:
          - json_result: json
    - create_app_domains:
        do:
          heroku_operations.create_app_domain:
            - username
            - password
            - app_name_or_id
            - json_body: "json_result"
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
          VERIFICATION_REQUIRED: VERIFICATION_REQUIRED
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
    - VERIFICATION_REQUIRED