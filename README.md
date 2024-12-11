# Park App GitOps with KEDA Autoscaling

## Steps to get started:

> You will need to be logged into your OpenShift cluster from the command line.

> If you do not have OpenShift GitOps or ArgoCD installed on your OpenShift cluster, you **must** be logged in as a user with enough access rights to install new operators.

1. Run `./setup-gitops.sh` if you do not already have OpenShift GitOps installed on your cluster.
2. Run `oc apply -k gitops/bootstrap`
3. Wait several minutes for the applications to spin up
4. Navigate to the `parks-app` Project on OpenShift to see your three deployments (parks-app, parks-weather, parks-dashboard) and note that there are **zero pods ready for parks-app**

   ```bash
   oc project parks-app
   oc get deployment

   NAME              READY   UP-TO-DATE   AVAILABLE   AGE
   parks-app         0/0     0            0           21h
   parks-dashboard   1/1     1            1           21h
   parks-weather     1/1     1            1           21h
   ```

5. Grab the route of the Parks Dashboard app and use a browser to navigate to the dashboard

   ```bash
   oc get route -n parks-app parks-dashboard -o jsonpath={.spec.host}

   parks-dashboard-parks-app.apps.cluster-lw5tn.lw5tn.sandbox2088.opentlc.com
   ```

7. Click on **Simulate weather warnings** in the Parks Dashboard app. You may need to press this button several times to get at least **five** weather events to trigger the Kafka KEDA trigger (based on configuration in the [kafka-scaled-object](./kustomize/bootstrap/custom-metrics-autoscaler/instance/base/kafka-scaled-object.yaml))
8. Back in your CLI, run `oc get deployment -n parks-app -w` and watch parks-app spin up and spin back down over the next 20 seconds (configured in the same place as #7)
