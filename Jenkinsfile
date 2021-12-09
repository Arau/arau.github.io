pipeline {
    agent any
    environment {
        ARTIFACTORY_URL = "docker-local.artifactory.storageos.net/docs/storageos-docs"
        STOS_DOGFOOD_URL = "hub.apps.storageos.net:443/docs"
        // replaceAll takes a regex, string. The regex below matches on / or .
        NEW_BRANCH = "$BRANCH_NAME".toLowerCase().replaceAll("\\/|\\.", "-")
        ROOT_VERSION = "v2.4"
        DOCS_URL = "http://${NEW_BRANCH}-docs.apps.storageos.net"
    }
    parameters {
        booleanParam(name: "NAMESPACE_CLUSTER", defaultValue: false)
    }
    stages {
        stage ('Printenv for context') {
            steps {
                sh 'printenv | sort'
             }
        }
        stage ('Build image') {
            steps {
                sh '''
                    sudo docker build \
                        --build-arg ROOT_VERSION=$ROOT_VERSION \
                        --build-arg URL="$DOCS_URL"  \
                        -t $GIT_COMMIT .

                    sudo docker tag $GIT_COMMIT $ARTIFACTORY_URL:$GIT_COMMIT
                    sudo docker tag $GIT_COMMIT $STOS_DOGFOOD_URL:$GIT_COMMIT
                '''
            }
        }

        stage ('Push images') {
                steps {
                    sh '#sudo docker push $ARTIFACTORY_URL:$GIT_COMMIT'
                    sh 'sudo docker push $STOS_DOGFOOD_URL:$GIT_COMMIT'
                }
        }

        stage('Download kubeconfig artifact') {
            steps {
                rtDownload (
                    serverId: "DEV",
                    spec: '''{
                              "files": [
                                {
                                  "pattern": "docker/docs/ci-df-kubeconfig.yaml",
                                  "target": ".kubeconfig/"
                                }
                             ]
                        }'''
                )
            }
        }
        stage('Create new kustomization for deployment') {
            steps {
                sh '''
                    cp -r ./build/k8s-manifests/branch-example ./build/k8s-manifests/$NEW_BRANCH
                    cd ./build/k8s-manifests/$NEW_BRANCH
                    find . -type f -exec sed -i "s/branch-example/$NEW_BRANCH/g" {} \\;
                    find . -type f -exec sed -i "s/commit-sha1/$GIT_COMMIT/g" {} \\;
                '''
            }
        }
        stage('Create namespace') {
            // We are skipping the NS creation by default because the cluster
            // already has the NS available. The section is left for
            // completeness. If the porject were to be deployed on a new
            // cluster, this section would need to be executed at least once.
            when { expression { params.NAMESPACE_CLUSTER } }
            steps {
                 sh '''
                    sudo docker run \
                        --rm \
                        --name release-docs-$GIT_COMMIT \
                        -v "$PWD":/app \
                        -w /app \
                        --env KUBECONFIG=/app/.kubeconfig/docs/ci-df-kubeconfig.yaml \
                        bitnami/kubectl:1.20 apply -f ./build/k8s-manifests/bases/00-docs-ns.yaml
                '''
            }
        }
        stage('Deploy docs to k8s') {
            steps {
                sh '''
                    sudo docker run \
                        --rm \
                        --name release-docs-$GIT_COMMIT \
                        -v "$PWD":/app \
                        -w /app \
                        --env KUBECONFIG=/app/.kubeconfig/docs/ci-df-kubeconfig.yaml \
                        bitnami/kubectl:1.20 apply --kustomize ./build/k8s-manifests/$NEW_BRANCH
                '''
            }
        }
        stage('Rollout latest changes to k8s deployment') {
            steps {
                sh '''
                    DEPLOYMENT=$NEW_BRANCH-docs
                    sudo docker run \
                        --rm \
                        --name release-docs-$GIT_COMMIT \
                        -v "$PWD":/app \
                        -w /app \
                        --env KUBECONFIG=/app/.kubeconfig/docs/ci-df-kubeconfig.yaml \
                        bitnami/kubectl:1.20 set image deployment/$DEPLOYMENT docs=$STOS_DOGFOOD_URL:$GIT_COMMIT
                '''
            }
        }
    }
    post {
        success {
            script {
                currentBuild.description = env.DOCS_URL
            }
        }
    }
}
