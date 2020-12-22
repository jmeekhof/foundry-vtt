#!/bin/bash
sudo apt install -y libssl-dev
curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
sudo apt install -y nodejs

sudo apt install -y nginx unzip

sudo mkdir -p /data
sudo mount ${device} /data

#Copy the service here
SERVICE_FILE=/etc/systemd/system/foundryvtt.service
(
sudo cat <<'EOF'
[Unit]
Description=Foundry VTT
After=network.target

[Service]
ExecStart=/usr/bin/node /data/foundryvtt/resources/app/main.js --port=${port}
Restart=always
User=ubuntu
# Note Debian/Ubuntu uses 'nogroup', RHEL/Fedora uses 'nobody'
Group=ubuntu
Environment=PATH=/usr/bin:/usr/local/bin
Environment=NODE_ENV=production
Environment=FOUNDRY_VTT_DATA_PATH=/data/foundrydata
WorkingDirectory=/data/foundrydata

[Install]
WantedBy=multi-user.target
EOF
) > $SERVICE_FILE

#Enable service
sudo systemctl daemon-reload
sudo systemctl enable foundryvtt
sudo systemctl start foundryvtt

#Create log directory for nginx
sudo mkdir -p /var/log/nginx/foundryvtt

#Alter nginx setup to allow larger file uploads
NGINX_CONF=/etc/nginx/conf.d/001-MAX-UPLOAD.conf
(sudo cat <<'EOF'
    client_max_body_size 10m;
EOF
) > $NGINX_CONF

#Setup reverse proxy
FOUNDRY_CONFIG=/etc/nginx/sites-available/foundryvtt
(sudo cat <<'EOF'
server {
    listen 80;

    # Adjust this to your the FQDN you chose!
    server_name                 ${host};

    access_log                  /var/log/nginx/foundryvtt/access.log;
    error_log                   /var/log/nginx/foundryvtt/error.log;

    location / {
        proxy_set_header        Host $host;
        proxy_set_header        X-Real-IP $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header        X-Forwarded-Proto $scheme;

        # Adjust the port number you chose!
        proxy_pass              http://127.0.0.1:${port};

        proxy_http_version      1.1;
        proxy_set_header        Upgrade $http_upgrade;
        proxy_set_header        Connection "Upgrade";
        proxy_read_timeout      90;

        # Again, adjust both your FQDN and your port number here!
        proxy_redirect          http://127.0.0.1:${port} http://${host};
    }
}
EOF
) > $FOUNDRY_CONFIG
sudo ln -s /etc/nginx/sites-available/foundryvtt /etc/nginx/sites-enabled/foundryvtt
sudo rm /etc/nginx/sites-enabled/default
sudo systemctl enable nginx
sudo systemctl start nginx
