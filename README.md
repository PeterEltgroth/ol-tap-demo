# OpenLegacy Hub CICS demo on Tanzu Application Platform

## Assumptions

A *nix compatible environemnt with a `bash` shell

## Pre-requisites

1. A [Tanzu Application Platform 1.3.x](https://network.tanzu.vmware.com/products/tanzu-application-platform/) environment with this [catalog-info](catalog/catalog-info.yaml) imported as a Registered Entity.
2. [Sign up for the free OpenLegacy 60 day trial](https://app.ol-hub.com/auth/sign-up)
   - If you need an extendtion beyond 60 days for now contact: [peltgroth@vmware.com](mailto:peltgroth@vmware.com)
3. Java 11 or higher
4. Install [Gradle](https://gradle.org/install/)
5. Install OpenLegacy CLI
   1. [Mac OS](https://hub-support.openlegacy.com/en/article/install-openlegacy-cli-mac-1610991)
   2. [Windows](https://hub-support.openlegacy.com/en/article/install-openlegacy-cli-windows-2890217)
6. Clone down this repository.

## Create the OpenLegacy Hub Project

1. Login to [OpenLegacy Hub](https://app.ol-hub.com/)
2. [Generate an OpenLegacy API Key](https://hub-support.openlegacy.com/en/article/generate-api-keys-5957463)
3. [Login to `ol` cli](https://hub-support.openlegacy.com/en/article/generate-api-keys-5957463): `ol login`
4. From this directory
      1. Allow execute on [ol-project.sh](ol-project.sh): `chmod +x ol-project.sh`
      2. Run `./ol-project.sh` to create the demo OpenLegacy Module, Assets, and Project.
5. Go to the Project and click **Generate Service**
![Generate Service image](images/Generate-Service.png)
1. Select SPRING-JAVA-REST
![SPRING-JAVA-REST image](images/SPRING-JAVA-REST.png)
1. Download the Service
![Download Generated image](images/Download.png)
1. Unzip: `unzip <my-project>.zip -d <destination-directory>`
2. `cd` into the unzipped directory
3.  Optional: Run `gradle bootRun` and check [localhost:8080/openapi/index.html](localhost:8080/openapi/index.html?url=/openapi/openapi.yaml)
![OpenAPI GUI](images/OpenAPI-local.png)

## Deploy into Tanzu Application Platform

Note: This deploys into the `default` Kubernetes namespace.

```bash
tanzu app wld apply demo-ol-cics \ # Or replace demo-ol-cics with your name
--local-path . \
--source-image <destimation image repository, e.g. my.azurecr.io/supply-chain/cics-demo> \
--type web \
--app ol-tap-demo \
--annotation autoscaling.knative.dev/minScale=1 \
--label apis.apps.tanzu.vmware.com/register-api="true" \
--param-yaml api_descriptor='{"type":"openapi","description":"Open Legacy generated CICS APIs.","owner":"demo-team","system":"ol-tap-demo","location":{"path":"/openapi/openapi.yaml"}}'
```

## Results

### Supply Chain
![Supply Chain image](images/Supply-Chain.png)

### API Explorer
![API Explorer image](images/API-Explorer.png)

### API Definition

Note: To enable OpenAPI **TRY IT OUT** the application must have [CORS set to allow requests from TAP GUI](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.3/tap/GUID-api-auto-registration-usage.html#setting-up-cors-for-openapi-specifications-5)

![API Definition image](images/API-Definition.png)

## References

- [OpenLegacy Public Hub Demos Repo - CICS samples](https://github.com/openlegacy/openlegacy-public-hub-demos/tree/master/mainframe-cics)
- [OpenLegacy TAP Proof-of-Concept CICS repo](https://github.com/PeterEltgroth/account-cics-microservice)