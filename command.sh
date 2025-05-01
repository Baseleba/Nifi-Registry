# Generate a keystore with a self-signed certificate for NiFi Registry
sudo keytool -genkeypair -alias nifi-registry -keyalg RSA -keysize 4096 -validity 365 \
  -keystore /opt/nifi-registry/conf/keystore.jks -storetype JKS \
  -dname "CN=nifi-registry.example.com, OU=DevOps, O=MyCompany, L=Orlando, ST=FL, C=US" \
  -storepass YourKeystorePassword -keypass YourKeyPassword


keytool -exportcert -alias nifi-registry -keystore /opt/nifi-registry/conf/keystore.jks \
  -file /opt/nifi-registry/conf/nifi-registry.crt -storepass YourKeystorePassword



  keytool -importcert -alias nifi-registry-cert -file /opt/nifi-registry/conf/nifi-registry.crt \
  -keystore /path/to/nifi/truststore.jks -storepass NiFiTruststorePassword -noprompt

# Create an empty truststore and import NiFi certificate
keytool -importcert -alias nifi-node-cert -file /opt/nifi-registry/conf/nifi-node.crt \
  -keystore /opt/nifi-registry/conf/truststore.jks -storepass YourTruststorePassword -noprompt


nifi.registry.security.truststore=/opt/nifi-registry/conf/truststore.jks
nifi.registry.security.truststoreType=JKS
nifi.registry.security.truststorePasswd=YourTruststorePassword

keytool -list -v -keystore /opt/nifi-registry/conf/keystore.jks -alias nifi-registry -storepass <yourpass> | grep "Owner:"


location /nifi-registry/ {
    proxy_pass https://localhost:9444/nifi-registry/;
    proxy_ssl_name localhost;
    proxy_http_version 1.1;

    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto https;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-Prefix /nifi-registry;

    # These are critical for reverse proxy logic
    proxy_set_header X-ProxyScheme "https";
    proxy_set_header X-ProxyHost $host;
    proxy_set_header X-ProxyPort "443";
    proxy_set_header X-ProxyContextPath "/nifi-registry";

    # Prevent 301 redirect weirdness
    proxy_redirect off;
}




server {
    listen 443 ssl http2;
    server_name registry.aiq.local;

    ssl_certificate     /etc/ssl/certs/nifi-sandbox.aiq.local.crt;
    ssl_certificate_key /etc/ssl/private/nifi-sandbox.aiq.local.key;

    location / {
        proxy_pass https://localhost:9444/;
        proxy_ssl_name localhost;
        proxy_http_version 1.1;

        proxy_pass_request_headers on;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
        proxy_set_header X-Forwarded-Host $host;
    }
}



