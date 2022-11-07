for ((i=1;i<=200;i++)); do
# Target existing service’s routes
curl "http://localhost:4000/#/about" -A 'dd-test-scanner-log';
# Target non existing service’s routes
curl "http://localhost:4000/#/about" -A 'dd-test-scanner-log';
done