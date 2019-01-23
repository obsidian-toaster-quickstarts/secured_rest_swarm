
# Booster Documentation

<https://appdev.prod-preview.openshift.io/docs/wf-swarm-runtime.html#mission-rest-http-secured-wf-swarm>

# Integration test

mvn install -Popenshift,openshift-it -DSSO_AUTH_SERVER_URL=$(oc get route secure-sso -o jsonpath='{"https://"}{.spec.host}{"/auth\n"}')
