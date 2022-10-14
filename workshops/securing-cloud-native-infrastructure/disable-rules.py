from json import dumps
import sys
import os
import requests
import json

# This script disables a set of CSPM rules based on their names


authenticationHeaders = {
  'DD-API-KEY': os.getenv('DD_API_KEY'),
  'DD-APPLICATION-KEY': os.getenv('DD_APP_KEY'),
}


def getAllRules():
  print("Retrieving all CSPM rules...")
  response = requests.get('https://api.datadoghq.com/api/v2/security_monitoring/rules?page[size]=10000', headers=authenticationHeaders)

  if response.status_code != 200:
    sys.stderr.write(f"Failed with status code {response.status_code}: {response.text}\n")
    sys.exit(1)
  
  rules = response.json().get('data')
  
  result = {}
  for rule in rules:
    result[rule.get('name')] = rule

  print(f"Successfuly retrieved {len(rules)} rules")
  return result

def disableRule(ruleId):
  headers = authenticationHeaders.copy()
  headers['Content-Type'] = 'application/json'

  response = requests.put(
    f"https://api.datadoghq.com/api/v1/security_analytics/rules/{ruleId}",
    headers=headers,
    data=json.dumps({'isEnabled': False})
  )
  if response.status_code != 200:
    sys.stderr.write('failed: ' + response.text + '\n')

def main():
  if len(sys.argv) != 2:
    sys.stderr.write('Usage: python disable-rules <input-file>\n\t<input-file>should contain the rule names to disable, one per line')
    sys.exit(1)

  inputFile = sys.argv[1]
  if inputFile == '-':
    ruleNames = sys.stdin.read().strip().split('\n')
  else:
    with open(inputFile) as input:
      ruleNames = input.read().strip().split('\n')
  
  rules = getAllRules()
  for ruleNameToDisable in ruleNames:
    rule = rules.get(ruleNameToDisable)
    if rule is not None:
      print(f"Disabling detection rule {rule.get('id')} ('{rule.get('name')}')")
      disableRule(rule.get('id'))
    else:
      sys.stderr.write(f"Warning: rule '{ruleNameToDisable}' not found, ignoring")

if __name__ == "__main__":
  main()