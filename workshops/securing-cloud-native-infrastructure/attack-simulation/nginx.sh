apt install -y nginx
cat > /etc/nginx/sites-available/default <<EOF
server {
        listen 8000 default_server;
        server_name _;

        location / {
                proxy_pass $APP_URL;
        }
}
EOF
systemctl restart nginx

python3 disable-rules.py - <<EOF
PIDs cgroup limit is used
EBS volume is encrypted
S3 bucket is configured with 'Block public access (bucket settings)'
Network ACLs do not allow ingress from 0.0.0.0/0 to remote server administration ports
ELBv2 load balancer is not internet facing
ELBv2 ALB is using a secure listener
S3 bucket employs default encryption at-rest
Multi-factor authentication is enabled for all IAM users with a console password
Outbound access on all ports is restricted
An AppArmor Profile is enabled
Container's root filesystem is mounted as read only
Restart attempts on container failure is limited to 5 attempts
Memory usage for containers is limited
Access keys are not created for IAM user during initial set up
Lambda function uses latest runtime environment version
TLS authentication for Docker daemon is configured
Docker is allowed to make changes to iptables
Insecure registries are not used
Only trusted users are allowed to control Docker daemon
Host's user namespaces are not shared
Host's network namespace is not shared
Docker socket is not mounted inside any containers
Outbound access on all ports is restricted
Rotation for customer created CMKs is enabled
S3 bucket access logging is enabled on the CloudTrail S3 bucket
EBS volume is encrypted
Network ACLs do not allow ingress from 0.0.0.0/0 to remote server administration ports
AWS Route Table created or modified
AWS security group created, modified or deleted
S3 bucket policy modified
AWS Console login without MFA
AWS EC2 subnet deleted
AWS Network Gateway created or modified
AWS CloudWatch log group deleted
EOF