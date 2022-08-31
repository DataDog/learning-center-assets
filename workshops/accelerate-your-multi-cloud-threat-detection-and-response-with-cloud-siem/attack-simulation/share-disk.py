import requests
import sys
import os

# Utility Python script to create a SAS URL for a specific disk
# The Azure authorization token to use is expected in the environment variable AZURE_TOKEN
# Note: We need this script because AFAIK it's not possible to authenticate with the az CLI using a raw access token
if len(sys.argv) != 4:
  sys.stderr.write('Usage: python share-disk.py subscription-id resource-group disk-name\n') 
  sys.exit(1)

azureToken = os.getenv('AZURE_TOKEN', None)
if azureToken is None:
  sys.stderr.write('Missing Azure token in AZURE_TOKEN\n')
  sys.exit(1)
_, subscriptionId, resourceGroup, diskName = sys.argv

beginExportUrl = f'https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Compute/disks/{diskName}/beginGetAccess?api-version=2022-03-02'

result = requests.post(
  url=beginExportUrl, 
  headers={
    'Authorization': f'Bearer {azureToken}',
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  }, 
  data='{"access": "Read", "durationInSeconds": 86400}'
)
if result.status_code != 202:
  sys.stderr.write(f'Failed with status code {result.status_code}\n')
  sys.exit(1)

statusUrl = result.headers.get('location')
if statusUrl is None:
  sys.stderr.write(f'Missing redirect, unknown error\n')
  sys.exit(1)

result = requests.get(statusUrl, headers={
  'Authorization': f'Bearer {azureToken}'
})
sasUrl = result.json().get('accessSAS')
if sasUrl is None:
  sys.stderr.write(f'Did not receive an access SAS. Response: {result.text}\n')
  sys.exit(1)

print(sasUrl)