#!/bin/bash

LANG=C
SLEEP_SECONDS=45

echo ""
echo "Installing GitOps Operator."

oc apply -k kustomize/bootstrap/openshift-gitops/operator/base

echo "Pause $SLEEP_SECONDS seconds for the creation of the gitops-operator..."
sleep $SLEEP_SECONDS

echo "Waiting for operator to start"
until oc get deployment openshift-gitops-operator-controller-manager -n openshift-gitops-operator
do
  sleep 5;
done

echo "Waiting for openshift-gitops namespace to be created"
until oc get ns openshift-gitops
do
  sleep 5;
done

echo "Waiting for deployments to start"
until oc get deployment cluster -n openshift-gitops
do
  sleep 5;
done

echo "Waiting for all pods to be created"
deployments=(cluster kam openshift-gitops-applicationset-controller openshift-gitops-redis openshift-gitops-repo-server openshift-gitops-server)
for i in "${deployments[@]}";
do
  echo "Waiting for deployment $i";
  oc rollout status deployment $i -n openshift-gitops
done

echo "GitOps Operator ready"

echo ""
echo "Installing GitOps Instance."

oc apply -k kustomize/bootstrap/openshift-gitops/instance/overlays/sync-wave-15

echo "Pause 10 seconds for the creation of the GitOps Instance..."
sleep 10

echo "Waiting for Argo CD to start"
until oc get argocd openshift-gitops -n openshift-gitops
do
  sleep 5;
done

echo "Argo CD Instance Ready"

sleep 1;
echo ""


echo "Now run oc apply -k gitops/bootstrap"
