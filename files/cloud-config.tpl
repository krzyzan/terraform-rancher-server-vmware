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
- path: /opt/letsencrypt/cli.ini
  permissions: "0640"
  owner: root
  content: |
    # Let's Encrypt site-wide configuration
    email = ${letsencrypt_email}
    server = ${letsencrypt_server}
    dns-cloudflare = True
    dns-cloudflare-credentials = /etc/letsencrypt/cloudflare.ini
    agree-tos = True
    preferred-challenges = dns
- path: /opt/letsencrypt/cloudflare.ini
  permissions: "0400"
  owner: root
  content: |
    # Cloudflare API credentials used by Certbot
    dns_cloudflare_email = ${cloudflare_email}
    dns_cloudflare_api_key = ${cloudflare_api_key}
runcmd:
# Horrible trickery to overcome non-persistent /etc in RancherOS
- [mkdir, -p, /opt/letsencrypt, /etc/letsencrypt]
- [mount, -o, bind, /opt/letsencrypt, /etc/letsencrypt]
# Expose certs as directory volume, as docker cannot handle changes to file volumes when certbot changes symlinks
- [mkdir, -p, /etc/rancher/ssl]
- [ln, -sf, /etc/letsencrypt/live/${hostname}.${domain}/cert.pem, /etc/rancher/ssl/cert.pem]
- [ln, -sf, /etc/letsencrypt/live/${hostname}.${domain}/privkey.pem, /etc/rancher/ssl/key.pem]
- [ln, -sf, /etc/letsencrypt/live/${hostname}.${domain}/chain.pem, /etc/rancher/ssl/cacerts.pem]
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
  services:
    certbot:
      image: certbot/dns-cloudflare
      command: ['certonly', '--non-interactive', '--domains', '${hostname}.${domain}']
      volumes:
      - /etc/letsencrypt:/etc/letsencrypt
      - /var/lib/letsencrypt:/var/lib/letsencrypt
      labels:
        cron.schedule: "0 */12 * * *"
    rancher-server:
      image: rancher/rancher:latest
      restart: unless-stopped
      ports:
      - 80:80
      - 443:443
      volumes:
      - /etc/rancher/ssl:/etc/rancher/ssl:ro
      - /etc/letsencrypt:/etc/letsencrypt:ro
      labels:
        io.rancher.os.after: certbot
  services_include:
    crontab: true
    open-vm-tools: true
  registry_auths: # Credentials only consumed by system-docker not user-docker!
    https://registry.${domain}:
      username: foo
      password: bar
