#!/bin/bash
gcloud components install kubectl

# Name hard-coded in: frontendconfig.yaml
STATIC_IP_NAME=online-boutique-ip

# Set up Cloud Armor
SECURITY_POLICY_NAME=online-boutique-security-policy # Name hard-coded in: backendconfig.yaml
gcloud compute security-policies create $SECURITY_POLICY_NAME --description "Block various attacks"

gcloud compute security-policies rules create 1000 --security-policy $SECURITY_POLICY_NAME --expression "evaluatePreconfiguredExpr('xss-stable')" --action "deny-403" --description "XSS attack filtering"

gcloud compute security-policies rules create 12345 --security-policy $SECURITY_POLICY_NAME --expression "evaluatePreconfiguredExpr('cve-canary')" --action "deny-403" --description "CVE-2021-44228 and CVE-2021-45046"

gcloud compute security-policies update $SECURITY_POLICY_NAME --enable-layer7-ddos-defense

gcloud compute security-policies update $SECURITY_POLICY_NAME --log-level=VERBOSE

# Set up an SSL policy in order to later set up a redirect from HTTP to HTTPs

SSL_POLICY_NAME=online-boutique-ssl-policy # Name hard-coded in: frontendconfig.yaml
gcloud compute ssl-policies create $SSL_POLICY_NAME --profile COMPATIBLE --min-tls-version 1.0

# Deploy the Kubernetes manifests in appropriate folder
kubectl apply -f ./release/release-cluster
fi 
