# Created by Florian TEISSEDRE - florian.teissedre@hpe.com

namespace: Heroku.content.json

operation:
  name: analyseJsonResponse  
  inputs:
    - json_response
  action:
    python_script: |
      import json
      j = json.loads(json_response)
      response_type = '0'
      try:
        r = j['id']
        if r in ['unauthorized', 'not_found', 'invalid_params', 'bad_request']:
          response_type = '-1'
      except:
        print "json is an array"
        r = "Array"

  outputs:
    - returnResult: response_type
    - idTypeResult: r
  results: 
    - SUCCESS: response_type == '0'
    - UNAUTHORIZED: r == 'unauthorized'
    - NOT_FOUND: r == 'not_found'
    - INVALID_PARAMS: r == 'invalid_params'
    - BAD_REQUEST: r == 'bad_request'
    - FAILURE