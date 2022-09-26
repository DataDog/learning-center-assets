##########################
# TROUBLESHOOTING SCRIPT #
##########################

# Requires pip install datadog-api-client termcolor requests

import os
import sys
from datetime import datetime

import requests
from datadog_api_client import ApiClient, Configuration
from datadog_api_client.v1.api.hosts_api import HostsApi
from datadog_api_client.v2.api.logs_api import LogsApi
from datadog_api_client.v2.api.processes_api import ProcessesApi
from datadog_api_client.v2.api.security_monitoring_api import SecurityMonitoringApi
from datadog_api_client.v2.model.logs_list_request import LogsListRequest
from datadog_api_client.v2.model.logs_list_request_page import LogsListRequestPage
from datadog_api_client.v2.model.logs_query_filter import LogsQueryFilter
from datadog_api_client.v2.model.security_monitoring_signal_list_request import SecurityMonitoringSignalListRequest
from datadog_api_client.v2.model.security_monitoring_signal_list_request_filter import (
    SecurityMonitoringSignalListRequestFilter,
)
from dateutil.relativedelta import relativedelta
from termcolor import colored

if os.getenv('DD_API_KEY') is None or os.getenv('DD_APP_KEY') is None:
    sys.stderr.write('Please set your Datadog credentials in the environment\n')
    sys.exit(1)

datadogApi = ApiClient(Configuration())
securityMonitoring = SecurityMonitoringApi(datadogApi)
logsApi = LogsApi(datadogApi)
hostsApi = HostsApi(datadogApi)
processesApi = ProcessesApi(datadogApi)


def warn(str):
    print(colored('[WARN]', 'yellow'), str)


def fail(str):
    print(colored('[FAIL]', 'red'), str)


def success(str):
    print(colored('[PASS]', 'green'), str)


def info(str):
    print(colored('[INFO]', 'blue', attrs=['bold']), str)


def listSignals(query):
    searchRequest = SecurityMonitoringSignalListRequest(
        filter=SecurityMonitoringSignalListRequestFilter(
            query=query,
            _from=(datetime.now() + relativedelta(days=-1))
        )
    )
    return securityMonitoring.search_security_monitoring_signals_with_pagination(body=searchRequest)


def validateCWSSignals():
    info('Validating CWS signals...')
    signals = listSignals('source:runtime-security-agent')
    expectedRules = {
        'DNS lookup for IP lookup service',
        'Process arguments match cryptocurrency miner',
        'DNS lookup for cryptocurrency mining pool',
        'Package installed in container',
        'Java process spawned shell'
    }

    for signal in signals:
        ruleName = signal['attributes']['attributes']['workflow']['rule']['name']
        if ruleName in expectedRules:
            success(f'CWS signal "{ruleName}" found')
            expectedRules.remove(ruleName)
        else:
            warn(f'Unexpected CWS signal {ruleName}')

    if len(expectedRules) > 0:
        fail('Missing CWS signals: \n\t' + '\n\t'.join(expectedRules))


def validateCloudSIEMSignals():
    info('Validating Cloud SIEM signals...')
    signals = listSignals('source:cloudtrail')
    expectedRules = {
        'AWS EBS Snapshot Made Public',
        'AWS EBS Snapshot possible exfiltration',
        'An EC2 instance attempted to enumerate S3 bucket',
        'AWS IAM policy changed'
    }
    foundRules = set()
    for signal in signals:
        triggeringRule = signal['attributes']['attributes']['workflow']['rule']
        ruleName = triggeringRule['name']
        if ruleName in expectedRules and ruleName not in foundRules:
            success(f'Cloud SIEM signal "{ruleName}"')
            expectedRules.remove(ruleName)
            foundRules.add(ruleName)
        else:
            warn(f'Unexpected Cloud SIEM signal "{ruleName}" found')

    if len(expectedRules) > 0:
        fail('Missing Cloud SIEM signals: \n\t' + '\n\t'.join(expectedRules))


def validateCSPMFindings():
    info('Validating CSPM findings')

    # No public API for this...
    url = 'https://app.datadoghq.com/api/v1/compliance_monitoring/findings/rule_based_view?to=' + str(
        round(1000 * datetime.now().timestamp()))
    headers = {
        'DD-API-KEY': os.getenv('DD_API_KEY'),
        'DD-APPLICATION-KEY': os.getenv('DD_APP_KEY')
    }
    findings = requests.get(url, headers=headers).json().get('rules', [])
    if len(findings) == 0:
        fail('No CSPM findings found')
        return

    expectedFindings = {
        'IAM policies that allow full "*:*" administrative privileges are not created',
        'IAM privileged user does have admin permissions to your AWS account',
        'EBS volume snapshot is not publicly shared with other AWS accounts',
        'Privileged containers are not used',
    }

    for finding in findings:
        # only consider FAILED findings
        if finding['stats']['fail'] == 0:
            pass
        ruleName = finding['name']
        if ruleName in expectedFindings:
            success(f'CSPM finding "{ruleName}"')
            expectedFindings.remove(ruleName)

    if len(expectedFindings) > 0:
        fail("Missing CSPM findings:\n\r" + '\n\r'.join(expectedFindings))


def hasLogsMatching(query):
    request = LogsListRequest(
        filter=LogsQueryFilter(
            query=query,
            # _from=str(round(1000*(datetime.now() + relativedelta(days=-1)).timestamp())), # -1 day ago
            _from="1970-01-01T00:00:00+00:00",
        ),
        page=LogsListRequestPage(limit=1)

    )
    logs = logsApi.list_logs(body=request)
    return len(logs.get('data', [])) > 0


def validateCloudTrailLogs():
    if hasLogsMatching('source:cloudtrail'):
        success('CloudTrail logs found')
    else:
        fail('No CloudTrail logs available')


def validateApplicationLogs():
    if hasLogsMatching('source:vulnerable-java-application'):
        success('Java application logs found')
    else:
        fail('Java application logs not found')


def validateHosts():
    hosts = hostsApi.list_hosts().get('host_list', [])
    expected = 2
    if len(hosts) >= expected:
        success(f'{expected} hosts properly reporting to Datadog')
    else:
        fail(f'Missing hosts reporting to Datadog (expected = {expected}, got {len(hosts)}')


def validateProcessMonitoring():
    processes = processesApi.list_processes(page_limit=10).get('data')
    if len(processes) > 0:
        success('Process monitoring properly reporting')
    else:
        fail('Process monitoring is not reporting any processes')

def validateWebapp():
    url = os.getenv('APP_URL')
    if url is None:
        fail('No APP_URL available in your environment')
        return
   
    response = requests.get(url)
    if response.status_code != 200:
        fail(f'Application ALB responded with status {response.status_code}')
        
    response = requests.get('http://127.0.0.1:8000')
    if response.status_code != 200:
        fail(f'Application reverse proxy responded with status {response.status_code}')
        
    success('Web application properly responding')
        
print(colored("Validating integrations", attrs=['bold']))
validateHosts()
validateProcessMonitoring()

print(colored("\nValidating logs", attrs=['bold']))
validateCloudTrailLogs()
validateApplicationLogs()

print(colored("\nValidating signals", attrs=['bold']))
validateCWSSignals()
validateCloudSIEMSignals()
validateCSPMFindings()

print(colored("\nValidating web application", attrs=['bold']))
validateWebapp()
