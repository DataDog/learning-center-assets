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