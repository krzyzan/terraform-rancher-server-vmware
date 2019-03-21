#cloud-config
hostname: ${hostname}
ssh_authorized_keys:
  - ${authorized_key}
write_files: # Customize NTP daemon
- container: ntp
  path: /etc/ntp.conf
  permissions: "0644"
  owner: root
  content: |
    server ntp.${domain} prefer
    restrict default nomodify nopeer noquery limited kod
    restrict 127.0.0.1
    restrict [::1]
    restrict localhost
    interface listen 127.0.0.1
rancher:
  network:
    dns: # Configure name servers and search domains
      nameservers:
      - ${primary_ns}
      - ${secondary_ns}
      search:
      - ${domain}
    interfaces: # Assign static IP to primary interface
      eth0:
        address: ${address}
        gateway: ${gateway}
        mtu: 1500
        dhcp: false
  services_include:
    crontab: true
    open-vm-tools: true
  registry_auths: # Credentials only consumed by system-docker not user-docker!
    https://registry.${domain}:
      username: foo
      password: bar
