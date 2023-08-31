#!/bin/bash

export TFE_AGENT_TOKEN="your_tfc_agent_token_here"

curl -fsSL -o /usr/local/bin/tfc-agent https://releases.hashicorp.com/tfc-agent/latest/tfc-agent_linux_amd64
chmod +x /usr/local/bin/tfc-agent

cat <<EOF > /etc/systemd/system/tfc-agent.service
[Unit]
Description=Terraform Cloud Agent

[Service]
ExecStart=/usr/local/bin/tfc-agent run --token \$TFE_AGENT_TOKEN
Restart=always
User=nobody
Group=nogroup

[Install]
WantedBy=multi-user.target
EOF

systemctl enable tfc-agent.service
systemctl start tfc-agent.service
