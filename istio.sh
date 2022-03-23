#!/bin/bash
gcloud components install kubectl
gcloud container clusters get-credentials gke-boutique-cluster --region europe-north1 --project team-2-a
kubectl apply -f ./release/istio-manifests.yaml