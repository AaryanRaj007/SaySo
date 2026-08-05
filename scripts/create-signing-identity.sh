#!/usr/bin/env bash
#
# Create the "SaySo Local Dev" self-signed code signing identity in the login
# keychain. Run once per machine; install-macos.sh uses it on every install.
#
# A real (even self-signed) certificate makes the app's designated requirement
# certificate-based rather than cdhash-based, so a granted Accessibility
# permission survives rebuilds instead of silently going stale.
#
set -euo pipefail

IDENTITY="SaySo Local Dev"
KEYCHAIN="$HOME/Library/Keychains/login.keychain-db"

if security find-identity -v -p codesigning | grep -q "$IDENTITY"; then
  echo "Identity '$IDENTITY' already exists. Nothing to do."
  exit 0
fi

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

cat > "$WORK/ext.cnf" <<EOF
[req]
distinguished_name=dn
x509_extensions=v3
prompt=no
[dn]
CN=$IDENTITY
[v3]
basicConstraints=critical,CA:false
keyUsage=critical,digitalSignature
extendedKeyUsage=critical,codeSigning
EOF

echo "==> Generating self-signed code signing certificate"
openssl req -x509 -newkey rsa:2048 -nodes -days 3650 \
  -config "$WORK/ext.cnf" -keyout "$WORK/key.pem" -out "$WORK/cert.pem" 2>/dev/null

# macOS Security.framework cannot read OpenSSL 3's default PKCS#12 encryption,
# so export with the legacy SHA1/3DES algorithms it understands.
openssl pkcs12 -export -out "$WORK/id.p12" -inkey "$WORK/key.pem" -in "$WORK/cert.pem" \
  -name "$IDENTITY" -passout pass:sayso \
  -certpbe PBE-SHA1-3DES -keypbe PBE-SHA1-3DES -macalg sha1

echo "==> Importing into login keychain"
security import "$WORK/id.p12" -k "$KEYCHAIN" -P sayso -T /usr/bin/codesign -A

echo "==> Trusting it for code signing"
security add-trusted-cert -r trustRoot -p codeSign -k "$KEYCHAIN" "$WORK/cert.pem"

security find-identity -v -p codesigning | grep "$IDENTITY"
echo "Done."
