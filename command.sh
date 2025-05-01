# Generate a keystore with a self-signed certificate for NiFi Registry
sudo keytool -genkeypair -alias nifi-registry -keyalg RSA -keysize 4096 -validity 365 \
  -keystore /opt/nifi-registry/conf/keystore.jks -storetype JKS \
  -dname "CN=nifi-registry.example.com, OU=DevOps, O=MyCompany, L=Orlando, ST=FL, C=US" \
  -storepass YourKeystorePassword -keypass YourKeyPassword


keytool -exportcert -alias nifi-registry -keystore /opt/nifi-registry/conf/keystore.jks \
  -file /opt/nifi-registry/conf/nifi-registry.crt -storepass YourKeystorePassword



  keytool -importcert -alias nifi-registry-cert -file /opt/nifi-registry/conf/nifi-registry.crt \
  -keystore /path/to/nifi/truststore.jks -storepass NiFiTruststorePassword -noprompt




