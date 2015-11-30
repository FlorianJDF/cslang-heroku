# Created by Florian TEISSEDRE - florian.teissedre@hpe.com
#################################################### 
# This flow performs an REST API call in order to update the HEROKU password 
# 
# Inputs: 
#   - username - the HEROKU username - Example: 'someone@mailprovider.com' 
#   - password - the HEROKU used for authentication
#   - json_body - the json used to update the HEROKU account
#
# Note : the json needs to be like : 
# {
#   "new_password": "newpassword",
#   "password": "currentpassword"
# } 
#
# Outputs: 
#   - return_result - the response of the operation in case of success, the error message otherwise 
#   - error_message - return_result if statusCode is not '200' 
#   - return_code - '0' if success, '-1' otherwise 
#   - status_code - the code returned by the operation 
#################################################### 

namespace: Heroku.content.account.current

imports:
  imports_operations: io.cloudslang.base.network.rest

flow:
  name: updatePasswordAccount
  inputs:
    - username
    - password
    - json_body
  workflow:
    - update_password_account:
        do:
          imports_operations.http_client_action:
            - url: "'https://api.heroku.com/account'"
            - method: "'PATCH'"
            - username: "username"
            - password: "password"
            - contentType: "'application/json'"
            - headers: "'Accept:application/vnd.heroku+json; version=3'"
            - body: json_body
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