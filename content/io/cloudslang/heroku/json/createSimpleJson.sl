# Created by Florian TEISSEDRE - florian.teissedre@hpe.com

namespace: io.cloudslang.heroku.json

operation:
  name: createSimpleJson  
  inputs:
    - list
  action:
    python_script: |
      error = 0
      if len(list) <= 0:
        error = -1
      jsonParameters = list.split("|")
      json = "{"
      jsonTab = []
      for current in range(len(jsonParameters)):
        parameter = jsonParameters[current].split(":")
        key = parameter[0]
        value = parameter[1]
        if (len(value) >2 ):
          jsonTab.append("\"" + key + "\":" + value)
      json += ','.join(jsonTab)
      json += "}"
      print json
  outputs:
    - json: json
  results:
    - FAILURE: error == -1
    - SUCCESS