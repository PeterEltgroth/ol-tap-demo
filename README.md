# OpenLegacy Hub CICS demo on Tanzu Application Platform

## Assumptions

A *nix compatible environment with a `bash` shell.

## Prerequisites

1. A [Tanzu Application Platform 1.4.x](https://network.tanzu.vmware.com/products/tanzu-application-platform/) installation
2. Sign up for the free [OpenLegacy 60 day trial](https://app.ol-hub.com/auth/sign-up)
   - If you need an extendtion beyond 60 days for now contact: [peltgroth@vmware.com](mailto:peltgroth@vmware.com)
3. Java 11 or higher
4. Install [Gradle](https://gradle.org/install/)
5. Install [OpenLegacy CLI](https://hub-support.openlegacy.com/en/install-and-log-in)
6. Install [Docker](https://docs.docker.com/engine/install/)
7. Clone down this repository

## Create the OpenLegacy Hub Project

1. Login to [OpenLegacy Hub](https://app.ol-hub.com/)
2. [Generate an OpenLegacy API Key](https://hub-support.openlegacy.com/en/article/generate-api-keys-5957463)
3. Login to [ol cli](https://hub-support.openlegacy.com/en/article/generate-api-keys-5957463): `ol login`
4. From this directory
      1. Allow execute on [ol-project.sh](ol-project.sh): `chmod +x ol-project.sh`
      2. Run `./ol-project.sh` to create the demo OpenLegacy Module, Assets, and Project
5. Go to the Project and click **Generate Service**
![Generate Service image](images/Generate-Service.png)
6. Select SPRING-JAVA-REST
![SPRING-JAVA-REST image](images/SPRING-JAVA-REST.png)
7. Download the Service
![Download Generated image](images/Download.png)
    - With an higher OpenLegacy License these manual steps could be done using `ol generate`
8. Unzip: `unzip <my-project>.zip -d <destination-directory>`
9. `cd` into the unzipped destination directory
10.  Optional: Run `gradle bootRun` and check [localhost:8080/openapi/index.html](localhost:8080/openapi/index.html?url=/openapi/openapi.yaml)
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

## Add the Catalog
1. See [Add your application to the Tanzu Application Platform GUI software catalog](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.3/tap/GUID-getting-started-deploy-first-app.html#add-your-application-to-tanzu-application-platform-gui-software-catalog-3)
2. For the **Repository URL** use: `https://github.com/PeterEltgroth/ol-tap-demo/blob/main/catalog/catalog-info.yaml`
3. After registering return to the home page to confirm registration

![Component list image](images/Component-list.png)

## Results in TAP GUI

### Supply Chain
![Supply Chain image](images/Supply-Chain.png)

### API Explorer
![API Explorer image](images/API-Explorer.png)

### API Definition

![API Definition image](images/API-Definition.png)

Note: To enable **TRY IT OUT** the application must have [CORS configured to allow requests from TAP GUI](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.3/tap/GUID-api-auto-registration-usage.html#setting-up-cors-for-openapi-specifications-5). If CORS is not configured try the REST APIs directly at:

`https://demo-ol-cics.<namespace>.<your-domain>/openapi/index.html`

---

To configure CORS create this class in `src/main/java/com/openlegacy/WebConfig.java`:

```java
package com.openlegacy;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.config.CorsRegistry;
import org.springframework.web.reactive.config.EnableWebFlux;
import org.springframework.web.reactive.config.WebFluxConfigurer;

@Configuration
@EnableWebFlux
public class WebConfig implements WebFluxConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {

        registry.addMapping("/*")
            .allowedOrigins("https://tap-gui.full.tap.isveng.com")
            .allowedMethods("POST", "OPTIONS")
            .allowedHeaders("*");
    }
}
```

---

### Component
![Component image](images/Component.png)

### Application Live View

[Application Live View docs](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.3/tap/GUID-app-live-view-about-app-live-view.html)

From the ol-tap-demo Component:
1. Click the *Runtime Resources* tab
2. Click the *Running* pod name, for example `demo-ol-cics-00001-deployment-<hash>`
3. Scroll down to the *Live View* section

---
**NOTE:**

By default the exposed actuator endpoints and data are restricted. To demonstrate the full capabilties of *Application Live View* modify the `management` section of `src/main/resources/application.yml` to be:

```yaml
management:
  endpoint:
    health:
      show-details: always
  endpoints:
    web:
      exposure:
        include: "*"
```

---

### Details
![App Live View Details image](images/Pod-App-Live-View-Details.png)

### Available Categories
![App Live View Categories image](images/Pod-App-Live-View-Categories.png)

### Health
![App Live View Health image](images/Pod-App-Live-View-Health.png)
#### Memory
![App Live View Memory image](images/Pod-App-Live-View-Memory.png)

#### Log Levels
![App Live View Log Levels image](images/Pod-App-Live-View-Log-Levels.png)

## Cleanup

1. Allow execute on [cleanup.sh](cleanup.sh): `chmod +x cleanup.sh`
2. Run `./cleanup.sh`
3. Unregister the ol-tap-demo component
![Unregister image](images/Unregister.png)
## References

- [OpenLegacy Public Hub Demos Repo - CICS samples](https://github.com/openlegacy/openlegacy-public-hub-demos/tree/master/mainframe-cics)
- [OpenLegacy TAP Proof-of-Concept CICS repo](https://github.com/PeterEltgroth/account-cics-microservice)
