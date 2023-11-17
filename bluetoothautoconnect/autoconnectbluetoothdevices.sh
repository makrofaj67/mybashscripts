#!/bin/bash

DEVICE_MAC="XX:XX:XX:XX:XX:XX" //change your mac here

is_connected() {
    bluetoothctl info $DEVICE_MAC | grep -q "Connected: yes"
}

while true; do
    if is_connected; then
        echo "Already connected"
        sleep 5
        continue
    else
        echo "Not connected, restarting bluetooth service to prevent possible issues"
        sudo systemctl restart bluetooth.service
        sleep 5
        while ! is_connected; do
            while ! is_indevicelist; do
                timeout 3s bluetoothctl scan on
            done
            bluetoothctl connect $DEVICE_MAC
        done
        echo "Connected"
        sleep 5
        bluetoothctl scan off
    fi
done
