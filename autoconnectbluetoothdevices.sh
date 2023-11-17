#!/bin/bash

DEVICE_MAC="F4:73:35:9F:A7:FF"

is_connected() {
    bluetoothctl info $DEVICE_MAC | grep -q "Connected: yes"
}

is_indevicelist() {
    bluetoothctl devices | grep -q $DEVICE_MAC
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
