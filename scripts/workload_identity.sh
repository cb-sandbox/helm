#!/bin/bash

set -x 

echo "----> Setting up Workload Identity"

echo "----> testing who this is running as with:"
echo "gcloud config list account"

gcloud config list account

GCP_SA_NAME=jenkins-build-sa
NAMESPACE=cloudbees-sda
K8S_SA_NAME=jenkins
# CLUSTER_PROJECT=cb-thunder-v2

gcloud iam service-accounts add-iam-policy-binding \
  --role roles/iam.workloadIdentityUser \
  --member "serviceAccount:cb-thunder-v2.svc.id.goog[$NAMESPACE/$K8S_SA_NAME]" \
  $GCP_SA_NAME@cb-thunder-v2.iam.gserviceaccount.com

kubectl annotate serviceaccount -n $NAMESPACE $K8S_SA_NAME \
  iam.gke.io/gcp-service-account=$GCP_SA_NAME@cb-thunder-v2.iam.gserviceaccount.com
