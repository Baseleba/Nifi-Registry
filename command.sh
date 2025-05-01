# Generate a keystore with a self-signed certificate for NiFi Registry
sudo keytool -genkeypair -alias nifi-registry -keyalg RSA -keysize 4096 -validity 365 \
  -keystore /opt/nifi-registry/conf/keystore.jks -storetype JKS \
  -dname "CN=nifi-registry.example.com, OU=DevOps, O=MyCompany, L=Orlando, ST=FL, C=US" \
  -storepass YourKeystorePassword -keypass YourKeyPassword





