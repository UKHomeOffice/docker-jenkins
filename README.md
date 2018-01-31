# docker-jenkins

This builds a Jenkins image and pushes up to Quay. The image includes the default plugins, Docker and sets up authentication via Keycloak.

To deploy Jenkins:

1. Create a repo called `kube-<your project>-jenkins`
1. [Request](https://github.com/UKHomeOffice/application-container-platform/blob/master/how-to-docs/README.md) a namespace and a robot token for that namespace in the ACP-CI cluster.
1. [Request](https://github.com/UKHomeOffice/application-container-platform/blob/master/how-to-docs/README.md) a Keycloak client to be created in the hod-ci realm. The ACP team will create the Kubernetes secret called jenkins, which will contain the Keycloak json in the necessary namespace:
`kubectl --context acp-ci -n <namespace> create secret generic jenkins --from-file=keycloak.json=/path/to/keycloak.json`
1. [Enable](https://github.com/UKHomeOffice/application-container-platform/blob/master/how-to-docs/README.md) the Drone build
1. Add the kube_secret_ci and kube_token_ci [secrets](https://github.com/UKHomeOffice/application-container-platform/blob/master/how-to-docs/README.md) to your drone build
1. `cp -pr {kube,scripts,.drone.yml.example} ../kube-<your project>-jenkins/.`
1. `cd ../kube-<your project>-jenkins`
1. `mv .drone.yml.example .drone.yml`
1. Update the contents of scripts/env.sh - remove acp-ci, and replace 'project' with the name of your project.
1. Push to deploy
