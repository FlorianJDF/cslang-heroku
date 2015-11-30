# Created by Florian TEISSEDRE - florian.teissedre@hpe.com
#################################################### 
# This flow performs an REST API call in order to add a domain on an application 
# 
# Inputs: 
#   - username - the HEROKU username - Example: 'someone@mailprovider.com' 
#   - password - the HEROKU used for authentication
#   - json_body - the json used to ann an HEROKU collaborator
#   - app_name_or_id - the name of the HEROKU application
#
# Note : the json needs to be like : 
# {
#  "hostname": "myhost.com"
# }
#
# Outputs: 
#   - return_result - the response of the operation in case of success, the error message otherwise 
#   - error_message - return_result if statusCode is not '200' 
#   - return_code - '0' if success, '-1' otherwise 
#   - status_code - the code returned by the operation 
#################################################### 

namespace: heroku.content.domains

imports:
  imports_operations: io.cloudslang.base.network.rest

flow:
  name: createAppDomain
  inputs:
    - username
    - password
    - app_name_or_id
    - json_body
  workflow:
    - create_app_domains:
        do:
          imports_operations.http_client_action:
            - url: "'https://api.heroku.com/apps/' + app_name_or_id +'/domains'"
            - method: "'POST'"
            - username: "username"
            - password: "password"
            - contentType: "'application/json'"
            - headers: "'Accept:application/vnd.heroku+json; version=3'"
            - body: "json_body"
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