#!/bin/bash

# Usage: ./oci-cert.sh <domain> <cert_dir>
# Example: ./oci-cert.sh vishak.ociateam.com /home/opc/certbot/config/live/vishak.ociateam.com

DOMAIN="$1"
CERT_DIR="$2"
COMPARTMENT_ID="ocid1.compartment.oc1..aaaaaaaaxxxxxxxx" #Replace with compartment ID where certs need to created/updated
REGION="us-ashburn-1" #Replace with region
PROFILE="DEFAULT" #Replace with Profile

# Check inputs
if [[ -z "$DOMAIN" || -z "$CERT_DIR" ]]; then
  echo "Usage: $0 <domain> <cert_dir>"
  exit 1
fi

CERT_NAME="$DOMAIN"
cd "$CERT_DIR" || { echo "Cert directory not found: $CERT_DIR"; exit 1; }

# Check required files
for file in cert.pem privkey.pem chain.pem; do
  [[ ! -f $file ]] && { echo "Missing $file in $CERT_DIR"; exit 1; }
done

# Look up existing cert
CERT_ID=$(oci --profile "$PROFILE" --region "$REGION" certs-mgmt certificate list \
  --compartment-id "$COMPARTMENT_ID" \
  --name "$CERT_NAME" \
  --all | jq -r '.data.items[0].id')

if [[ -z "$CERT_ID" || "$CERT_ID" == "null" ]]; then
  echo "No existing certificate found. Creating $CERT_NAME..."
  oci --profile "$PROFILE" --region "$REGION" certs-mgmt certificate create-by-importing-config \
    --compartment-id "$COMPARTMENT_ID" \
    --name "$CERT_NAME" \
    --certificate-pem "$(cat cert.pem)" \
    --private-key-pem "$(cat privkey.pem)" \
    --cert-chain-pem "$(cat chain.pem)"
else
  echo "Updating existing certificate $CERT_NAME..."
  oci --profile "$PROFILE" --region "$REGION" certs-mgmt certificate update-certificate-by-importing-config-details \
    --certificate-id "$CERT_ID" \
    --certificate-pem "$(cat cert.pem)" \
    --private-key-pem "$(cat privkey.pem)" \
    --cert-chain-pem "$(cat chain.pem)"
fi

echo "Done with $CERT_NAME"
