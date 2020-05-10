# openvpn-launcher
A simple bash script to easily start, stop and check status of the OpenVPN client.

## Installation
1. Clone or download the repository.
2. Change `CONFIG_FILE` to be your .ovpn config file.
3. (Optional) Create an alias in you .bashrc. Example: `alias vpn="~/Scripts/vpn.sh"`

## Usage

##### Start the VPN daemon
`vpn start`

##### Stop the VPN daemon
`vpn stop`

##### Show VPN status and public IP address
`vpn status`
