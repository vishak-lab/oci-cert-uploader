# oci-cert-uploader

# oci-cert-uploader

A simple script to **import or update SSL certificates** into **Oracle Cloud Infrastructure (OCI) Certificate Management Service**.

This works with certificates from **any provider** – Let’s Encrypt, Sectigo, DigiCert, etc.

---

## 🔧 What This Script Does

- Reads a certificate (`fullchain.pem`) and private key (`privkey.pem`) from your local file system.
- Checks if a certificate for the given domain already exists in OCI:
  - ✅ If it exists → updates the certificate.
  - 🆕 If not → creates a new certificate entry.
- Can be scheduled to run every 30 days using `cron` or any automation tool.

---

## ✅ Requirements

- [OCI CLI](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm) installed and configured.
- OCI IAM policy that allows managing certificates in the target compartment.
- Valid certificate and private key files on disk.

By default, the script assumes the following directory structure (compatible with Let's Encrypt):

