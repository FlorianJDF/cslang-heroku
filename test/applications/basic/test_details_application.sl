# Created by Florian TEISSEDRE - florian.teissedre@hpe.com

namespace: heroku.test.applications.basic

imports:
  heroku_operations: heroku.content.applications.basic
  json_operations: Heroku.content.json
flow:
  name: test_details_application
  inputs:
    - app_name_or_id
    - username
    - password
  workflow:
    - details_app:
        do:
          heroku_operations.detailsApp:
            - app_name_or_id
            - username
            - password
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