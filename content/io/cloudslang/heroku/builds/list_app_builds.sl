# Created by Florian TEISSEDRE - florian.teissedre@hpe.com
#################################################### 
# This flow performs an REST API call in order to get the details of all the builds of an HEROKU application 
# 
# Inputs: 
#   - username - the HEROKU username - Example: 'someone@mailprovider.com' 
#   - password - the HEROKU used for authentication
#   - app_name_or_id - the name or the id of the HEROKU application
# Outputs: 
#   - return_result - the response of the operation in case of success, the error message otherwise 
#   - error_message - return_result if statusCode is not '200' 
#   - return_code - '0' if success, '-1' otherwise 
#   - status_code - the code returned by the operation
#
# Note : Use the operation json/analyseJsonResponse.sl in order to analyse the output of this operation !
# 
#################################################### 

namespace: io.cloudslang.heroku.builds

imports:
  imports_operations: io.cloudslang.base.network.rest

flow:
  name: list_app_builds
  inputs:
    - username
    - password
    - app_name_or_id
  workflow:
    - app_builds:
        do:
          imports_operations.http_client_action:
            - url: "'https://api.heroku.com/apps/' + app_name_or_id +'/builds'"
            - method: "'GET'"
            - username: "username"
            - password: "password"
            - contentType: "'application/json'"
            - headers: "'Accept:application/vnd.heroku+json; version=3'"
        publish: 
          - return_result
          - error_message
          - return_code
          - status_code
  outputs:
    - return_result
    - error_message
    - return_code
    - status_code