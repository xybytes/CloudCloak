#!/bin/bash


# Update package list
apt update

# Install dante-server package
apt install dante-server -y

# Remove previous configuration
rm /etc/danted.conf

# Create an empty configuration file
touch /etc/danted.conf

# Add content to the configuration file
cat > /etc/danted.conf <<EOF
logoutput: syslog                     # Output will be written to syslog
user.privileged: root                 # User running danted with privileges
user.unprivileged: nobody             # Unprivileged user for connecting

# The listening network interface or address.
internal: 0.0.0.0 port=1080

# The proxying network interface or address.
external: eth0

# socks-rules determine what is proxied through the external interface.
socksmethod: none

# client-rules determine who can connect to the internal interface.
clientmethod: none

# Allow access from all IPs
client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
}

# Allow access to all IPs
socks pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
}
EOF

# Allow incoming connections on port 1080
ufw allow 1080

# Restart dante server
systemctl restart danted.service
