#!/bin/bash

# Replace with your own .ovpn config file path.
CONFIG_FILE="/etc/openvpn/ovpn_udp/us5038.nordvpn.com.udp.ovpn"

STATUS_FILE="$HOME/.vpn-status.tmp"
IP_ECHO_URL="http://ipecho.net/plain"

if [ "$1" = "stop" ]; then
    echo "Stopping VPN..."
    killall openvpn
    rm -f $STATUS_FILE
    echo "VPN stopped."
    
elif [ "$1" = "status" ]; then
    if [ ! -f $STATUS_FILE ]; then
        echo "[INACTIVE] You are not protected."
    else
        read -r IP_ON_STARTUP<$STATUS_FILE
        CURRENT_IP=`wget $IP_ECHO_URL -O - -q ; echo`
        if [ "$CURRENT_IP" = "$IP_ON_STARTUP" ]; then
            echo "[ACTIVE] You are protected: ${CURRENT_IP}"
        else
            echo "[INACTIVE] You are not protected."
        fi
    fi
    
elif [ "$1" = "start" ]; then
    OLD_IP=`wget $IP_ECHO_URL -O - -q ; echo`
    echo "Starting VPN..."
    openvpn --config $CONFIG_FILE --daemon
    
    # Check if the IP changed. We might have to retry a few times while the daemon starts up.
    CONNECTION_SUCCESSFUL=false
    for i in {1..10}
    do
        NEW_IP=`wget $IP_ECHO_URL -O - -q ; echo`
        if [ "$NEW_IP" != "$OLD_IP" ]; then
            CONNECTION_SUCCESSFUL=true
            break
        fi
        sleep 0.5
    done
    
    if [ "$CONNECTION_SUCCESSFUL" = true ]; then
        echo "VPN started:"
        echo "Old IP: ${OLD_IP}"
        echo "New IP: ${NEW_IP}"
        # Write IP infos to STATUS_FILE.
        touch $STATUS_FILE
        echo $NEW_IP >> $STATUS_FILE
    else
        echo "[ERROR] Failed to start VPN"
        echo "Please retry"
    fi
    
else
    echo "[ERROR] Unknown command"
    
fi
