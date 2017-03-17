# Introduction

## Basic Functionality

This project exposes a simple REST endpoint where the service `greeting` is available, but properly secured, at this address `http://hostname:port/greeting`
and returns a json Greeting message after the application issuing the call to the REST endpoint has been granted to access the service.

```json
{
    "content": "Hello, World!",
    "id": 1
}
```

The id of the message is incremented for each request. To customize the message, you can pass as parameter the name of the person that you want to send your greeting.

## Security Constraints

To manage the security, roles & permissions to access the service, a [Red Hat SSO](https://access.redhat.com/documentation/en/red-hat-single-sign-on/7.0/securing-applications-and-services-guide/securing-applications-and-services-guide) backend will be installed and configured for this project.
It relies on the Keycloak project which implements the OpenId connect specification which is an extension of the Oauth2 protocol.

After a successful login, the application will receive an `identity token` and an `access token`.
The identity token contains information about the user such as username, email, and other profile information.
The access token is digitally signed by the realm and contains access information (like user role mappings).

This `access token` is typically formatted as a JSON Token that the WildflySwarm application will use with its Keycloak adapter to determine what resources it is allowed to access on the application.
The configuration of the adapter is defined within the `app/src/main/webapp/WEB-INF/keycloak.json` file using these properties:

```
{
  "realm": "${sso.realm:master}",
  "resource": "${sso.clientId:secured-swarm-endpoint}",
  "realm-public-key": "${sso.realm.public.key:MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoETnPmN55xBJjRzN/cs30OzJ9olkteLVNRjzdTxFOyRtS2ovDfzdhhO9XzUcTMbIsCOAZtSt8K+6yvBXypOSYvI75EUdypmkcK1KoptqY5KEBQ1KwhWuP7IWQ0fshUwD6jI1QWDfGxfM/h34FvEn/0tJ71xN2P8TI2YanwuDZgosdobx/PAvlGREBGuk4BgmexTOkAdnFxIUQcCkiEZ2C41uCrxiS4CEe5OX91aK9HKZV4ZJX6vnqMHmdDnsMdO+UFtxOBYZio+a1jP4W3d7J5fGeiOaXjQCOpivKnP2yU2DPdWmDMyVb67l8DRA+jh0OJFKZ5H2fNgE3II59vdsRwIDAQAB}",
  "auth-server-url": "${sso.auth.server.url:http://localhost:8180/auth}",
  "ssl-required": "external",
  "disable-trust-manager": true,
  "bearer-only": true,
  "use-resource-role-mappings": true,
  "credentials": {
    "secret": "${sso.secret:1daa57a2-b60e-468b-a3ac-25bd2dc2eadc}"
  }
}
```

## Red Hat SSO

The security context is managed by Red Hat SSO using a realm (defined using the `sso.realm` property) where the adapter to establish a trusted TLS connection will use the Realm Public key defined using the `sso.realm-public-key` property.
To access the server, the parameter `sso.auth-server-url` is defined using the TLS address of the host followed with `/auth`.
To manage different clients or applications, a resource has been created for the realm using the property `sso.clientId`.
This parameter, combined with the `credentials.secret` property, will be used during the authentication phase to log in the application.
If, it has been successfully granted, then a token will be issued that the application will use for the subsequent calls.

The project is split into two Apache Maven modules - `app` and `sso`.
The `App` module exposes the REST Service using WildflySwarm.
The `sso` module is a submodule link to the [redhat-sso](https://github.com/obsidian-toaster-quickstarts/redhat-sso) project
 that contains the OpenShift objects required to deploy the Red Hat SSO Server 7.0 as well as a Java command line client
 driver to access this secured endpoint.

The goal of this project is to deploy the quickstart in an OpenShift environment (online, dedicated, ...).

# Prerequisites

To get started with these quickstarts you'll need the following prerequisites:

Name | Description | Version
--- | --- | ---
[java][1] | Java JDK | 8
[maven][2] | Apache Maven | 3.2.x
[oc][3] | OpenShift Client | v3.3.x
[git][4] | Git version management | 2.x

[1]: http://www.oracle.com/technetwork/java/javase/downloads/
[2]: https://maven.apache.org/download.cgi?Preferred=ftp://mirror.reverse.net/pub/apache/
[3]: https://docs.openshift.com/enterprise/3.2/cli_reference/get_started_cli.html
[4]: https://git-scm.com/book/en/v2/Getting-Started-Installing-Git

The first time you clone this secured-swarm-rest project, you need to initialize the sso submodule. You can do this by
either:
  1. using `git clone --recursive https://github.com/obsidian-toaster-quickstarts/secured_rest_swarm`

or

  1. using `git clone https://github.com/obsidian-toaster-quickstarts/secured_rest_swarm`
  1. `cd sso`
  1. `git submodule init`
  1. `git submodule update`

# Setting up OpenShift and the RH SSO Server

If you have not done so already, open up the sso/README.adoc or view it online [here](https://github.com/obsidian-toaster-quickstarts/redhat-sso/blob/master/README.adoc)
and follow the OpenShift Online section to setup your OpenShift environment and deploy the RH SSO server.

Make note of the SSO_AUTH_SERVER_URL value you received after deploying the RH SSO server. If you missed that step, return
to https://github.com/obsidian-toaster-quickstarts/redhat-sso/blob/master/README.adoc#determine-the-sso_auth_server_url-value
section and follow the instruction to obtain it.

# Build and deploy the Application

1. Build the top level project once

  ```
  mvn clean install
  ```

2. Next, the WildFly Swarm application should be packaged and deployed. This process will generate the uber jar file, the OpenShift resources
   and deploy them within the namespace of the OpenShift Server

    ```
    cd app
    mvn fabric8:deploy -Popenshift
    ```
# Access the Secured Endpoints

Return to the sso/README.adoc and continue at the "Access the Secured Endpoints" section.
