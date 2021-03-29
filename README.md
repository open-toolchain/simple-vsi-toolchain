

# Develop a Simple Java Application and Deploy on Virtual Server (Virtual Machine)

+ [Prerequisites](#prerequisites-)
+ [Application Repository Configuration](#application-repository-configuration)
+ [Inventory Repository Configuration](#inventory-repository-configuration)
+ [Delivery Pipeline Configurations](#delivery-pipeline-configurations) 
+ [Advanced User Scenarios](#advanced-user-scenarios-)
+ [Additional Information](#additional-information)
    - [RollBack to an older version of deployed application](#rollback-to-an-older-version-of-deployed-application)
    - [GitOps Flow](#gitops-flow)
    - [Customise the build and deploy script](#customise-the-build-and-deploy-script)
        - [Modify the Continous Integration Pipeline task](#modify-the-continous-integration-pipeline-task)
        - [Modify the Continuous Deployment Pipeline task](#modify-the-continous-deployment-pipeline-task)
+ [Learn more](#learn-more)

### Continuously Deliver a Java Application to the Virtual Server Instance.

  

By following this tutorial, you can create an open toolchain, and then use the toolchain and DevOps practices to develop a simple Java web application that you deploy to the IBM Cloud® Virtual Server Instance.  

This Simple Java application exposes an HTTP Endpoint at port 8080 of the host machine to present a Hello World Greeting message at the **http://{VSI-IP-ADDRESS}:8080/v1/** HTTP Path. The application utilizes a maven build system to provide build and test capability. The application comes preconfigured for a DevOps toolchain that provides continuous delivery with source control, issue tracking, online editing, and deployment to the IBM Virtual Server Instance.  

The application code is stored in the application source control repository whereas the build and deploy scripts are stored in the pipeline source control repository. The build and deploy scripts can be customized to suit the development needs of the application.  

The toolchain implements the following best practices:

- Builds application binary on every Git commit, sets a tag based on build number, timestamp, and commit id for traceability

- Creates IBM Cloud Storage Instance and Bucket to store the transient build binaries out-of-box. For advanced users, the IBM Cloud Storage Instances and Buckets to store binaries can be customized to utilize existing resources.

- For advanced users with versioning requirements for the build artifacts, the toolchain also supports Artifactory as artifact store. An existing artifactory repository can be configured and integrated with the toolchain to support the versioning of the build artifacts.

- GitOps Flow to deploy changes to the Deployment Environment.
  

# ![Icon](https://github.com/open-toolchain/simple-vsi-toolchain/blob/master/.bluemix/images/toolchain.png)
 

---

### Prerequisites:
 

-  **Virtual Server Instance**

This toolchain requires a Virtual Server Instance running a variant of Linux/Unix in IBM Cloud. If you don't have one, then you need to [Create a Virtual Server Instance](https://cloud.ibm.com/docs/vpc?topic=vpc-creating-virtual-servers) in IBM Cloud which serves as the target host where the Java Application should be deployed.

* The Virtual Server Instance needs to have a Floating IP that is accessible over the public internet. [Reserve Floating IP Address](https://cloud.ibm.com/docs/vpc?topic=vpc-creating-a-vpc-using-the-ibm-cloud-console#reserving-a-floating-ip-address) to connect to Virtual Server Instance over internet.

* Please ensure that the Security Group assigned to the Virtual Server Instance has Inbound rule that allows access to the ssh port (default port 22). [Update Security Group](https://cloud.ibm.com/docs/security-groups?topic=security-groups-getting-started) of the default VPC or the VPC to which the Virtual Server Instance belongs.

* The toolchain needs the login credentials, preferably of a non-privileged user, to connect to the Virtual Server Instance to deploy and run the built application binaries. The toolchain supports credential in the form of Username/Password or Username/SSH-Keys combination. Use [SSh Keys](https://cloud.ibm.com/docs/vpc-on-classic-vsi?topic=vpc-on-classic-vsi-ssh-keys#ssh-keys) to login as privileged user to your VSI and create additional non-privileged user for the toolchain to carry out the deployment operations.

* The toolchain performs health check over the deployed application. The sample Java Application create a web server that listens to incoming requests as port 8080. Therefore, it is required to [Update Security Group](https://cloud.ibm.com/docs/security-groups?topic=security-groups-getting-started) in order to add an inbound rule for `TCP` allow port `8080` to access the application.

**Note:**

If you are providing Username and Password, enable **PasswordAuthentication** in the Virtual Server Instance.

  

### Advanced User Scenarios:

The Continuous Integration (CI) Pipeline listens to changes in the application source code and triggers a CI Pipeline Run whenever a change is pushed to the application repository. The result of a successful CI Run is a artifact which is pushed to an intermediate storage (IBM Cloud Object Store or Artifactory). The Continuous Deployment (CD) Pipeline copies this artifact to the target Virtual Server Instance and performs application deployment. The toolchain provides user with an option to use either IBM Cloud Object Store (COS) or Artifactory as an intermediate storage to store the build binaries.

-  **Cloud Object Store (Default)** - The toolchain utilizes IBM Cloud Store (COS) to store transient application artifacts. In case user does not have an instance of IBM COS, toolchain creates one on behalf of user. The toolchain uses this newly created instance of IBM COS to create a bucket which will store the application artifacts. Alternately, user can also configure the toolchain to utilise an existing IBM COS Bucket or [Create Bucket](https://cloud.ibm.com/docs/cloud-object-storage/basics?topic=cloud-object-storage-provision)

-  **Artifactory (Optional)** - The toolchain also provides the capability to utilize an existing instance of JFrog Artifactory as intermittent storage to store the application artifacts (for ex. jar, exe).

Please note:

- If artifactory is configured and integrated then artifactory is used.

- If the COS bucket name is configured then corressponding bucket is used.

- If neither Artifatory nor COS bucket name is configured, then toolchain creates a COS instance in the default resource group. Once a COS Instance is successfully created, toolchain creates a bucket within the newly created COS Instance and use the same for storing artifacts.

---

### To get started, click this button:

[![Create toolchain](https://cloud.ibm.com/devops/graphics/create_toolchain_button.png)](https://cloud.ibm.com/devops/setup/deploy?repository=https://github.com/open-toolchain/simple-vsi-toolchain.git&env_id=ibm:yp:us-south&pipeline_type=tekton)

---

### Steps

1. On the Create Page, please provide inputs for mentioned fields

- Toolchain Name - Unique name to identify your toolchain

- Region - Select the region where toolchain is to be deployed (Ex: us-south)
 

![Toolchain Details](https://github.com/open-toolchain/simple-vsi-toolchain/blob/master/.bluemix/docs-images/toolchain-header.png)

  

### Application Repository Configuration


![Toolchain Details](https://github.com/open-toolchain/simple-vsi-toolchain/blob/master/.bluemix/docs-images/app-repo.png)

  

### Inventory Repository Configuration

1. Inventory repo is used to capture the build and artifact metadata.

2. Successful CI Build uploads the artifact to COS/Artifactory and commits the build metadata in JSON Format to Inventory Repository. The CD Pipeline triggers pipeline run to fetch the artifact  from COS/Artifactory and deploys it to the Virtual Server Instance. 

![Toolchain Details](https://github.com/open-toolchain/simple-vsi-toolchain/blob/master/.bluemix/docs-images/inventory-repo.png)

  

### Delivery Pipeline Configurations

1. On Create Page, please navigate to "Delivery Pipeline" Tab and fill in details:

2. IBM Cloud API Key - Use an existing key or create a new key. This key is used by the toolchain to interact with other integrated cloud services.

2. Virtual Server Instance Region - Region where Virtual Server Instance is running. (Ex. us-south)

3. Virtual Server Instance - Floating IP Address / DNS Name of the Virtual Server Instance

4. Authentication Type - User Credentials / SSH Key.
    - User Credentials:
        - User Name - Username of the Virtual Server Instance user with permission to deploy and run the application.
        - Password - Password of the Virtual Server Instance user with permission to deploy and run the application.

    - SSH Credentials:
        - User Name - Username of the Virtual Server Instance user with permission to deploy and run the application.
        - SSH KEY - Private SSH Key of the Virtual Server Instance user to deploy and run the application.

![Virtual Server Instance Details](https://github.com/open-toolchain/simple-vsi-toolchain/blob/master/.bluemix/docs-images/Deliver-pipeline.png)

### More Tool configurations:

1. Cloud Object Storage (Advanced User Scenarios) - For users with an existing Cloud Object Store Instance, navigate to the "More Tools" Tab and add details about your Cloud Object Store Instance.

- Bucket Name in your Cloud Object Storage Instance - Provide the name of the bucket to store the intermediate build artifacts. If you are provide the bucket name, ensure that you create the bucket in the same region where the toolchain is created. This is to ensure that pipeline can access the bucket.

![Cloud Object Storage Integration Details](hhttps://github.com/open-toolchain/simple-vsi-toolchain/blob/mmaster/.bluemix/docs-images/COS-conf.png)

2. Artifactory (Advanced User Scenarios) - For users with an existing Artifactory setup, navigate to the "More Tools" Tab and provide details about your Artifactory Instance:

| Input Parameter | Description |
|--|--|
|  Artifactory Server URL |  HTTP URL of the Artifactory Server |
| Type | Choose from (npm/maven/docker) |
| Artifactory UserID | UserID to login to the Artifactory Server |
| Artifactory APIKey | Generated by the User (Existing/New) |
| APIKey |  Release URL for the artifactory repo where artifacts are to be stored |

  

#### Note: Some fields in the artifactory are mandatory only when you do the artifactory configuration.

![Artifactory Integration Details](https://github.com/open-toolchain/simple-vsi-toolchain/blob/master/.bluemix/docs-images/Artifactory-conf.png)

### Additional Information

#### RollBack to an older version of deployed application

If you want to revert your current deployed version of application and install last working version utilise the GitOps Workflow model as described in steps below
  

1.  Clone the Inventory Repository. 
```
git clone <inventory-repo-url>
```

2. List commits pushed by CI pipeline after each successful CI Pipeline Run.
```
git log 
```
3.  Checkout master branch of Inventory Repository.
```
git checkout master
```
4.  Fetch the ID of the last commit made to the Inventory Repository.
```
lastCommitID=$(git log --format="%H" -n 1)
``` 
5. Revert the last commit. Please provide a commit message for this revert.
```
git revert $lastCommitID
``` 
6.  Push the change to inventory repo. Note: The action triggers the CD Pipeline Run for application deployment.
```
git push origin master --force
```  

#### GitOps Flow  

Simple VSI Toolchain follows the GitOps Workflow model. The model stores build metadata from each successful build in a separate repository (Inventory Repository). The default configuration of Continuous Deployment Pipeline triggers a pipeline run whenever a successful build metadata is pushed to the master branch. 

As best practice, user can create a branch in Inventory Repository for each deployment environment. The latest commit to the branch contains metadata of the artifact version deployed in the corresponding environment. Below steps guides user to create a workflow 

1. Create a VSI Toolchain. 

2. Once the toolchain is configured successfully, click on the Inventory Repository.
![Inventory Repository](https://github.com/open-toolchain/simple-vsi-toolchain/blob/master/.bluemix/docs-images/GitOps-1.png)

3. Create a branch for each of deployment environment ( For example: Production)
![Create environment branch](https://github.com/open-toolchain/simple-vsi-toolchain/blob/master/.bluemix/docs-images/GitOps-2.png)

4. Navigate to CD Pipeline > Triggers. Modify the trigger with Source as Inventory Repository with the branch which you want to trigger the CD-Pipeline(Master).
![Change CD Pipeline Trigger](https://github.com/open-toolchain/simple-vsi-toolchain/blob/master/.bluemix/docs-images/GitOps-3.png)

5. Perform multiple changes/commits to your Application Source Code. Note that these changes will not be deployed to your environment automatically.
![Perform Multiple Commits](https://github.com/open-toolchain/simple-vsi-toolchain/blob/master/.bluemix/docs-images/GitOps-4.png)

6. Raise Pull/Merge Request to merge changes from master branch to target (prod) environment branch. 
![Raise Merge Request](https://github.com/open-toolchain/simple-vsi-toolchain/blob/master/.bluemix/docs-images/GitOps-5.png)

7. Submit Pull/Merge Request to merge changes. As can be seen here master branch is 4 commits ahead of prod branch. The current merge request will merge changes from master to prod branch in effect deploying the artifact which contains changes pertaining to those 4 commits.
![Raise Merge Request](https://github.com/open-toolchain/simple-vsi-toolchain/blob/master/.bluemix/docs-images/GitOps-6.png)

8. Click on the Merge Icon. This action will trigger the CD pipeline run which is listening for changes on prod branch of the Inventory Repository.
![Submit Merge Request](https://github.com/open-toolchain/simple-vsi-toolchain/blob/master/.bluemix/docs-images/GitOps-7.png) 

9. Verify the CD Pipeline Run. 
![Submit Merge Request](https://github.com/open-toolchain/simple-vsi-toolchain/blob/master/.bluemix/docs-images/GitOps-8.png) 

#### Customise the build and deploy script

Simple VSI Toolchain leverages tekton perform the pipeline tasks for the build and deploy pipelines. Users can configure the build and deploy steps by making changes to the Pipeline Code which is maintained in the Pipeline Repository. 

##### Modify the Continous Integration Pipeline task

The CI Pipeline is responsible for compiling the application source code, running unit test and other tools. Users can modify the existing tasks for the changing needs of their application. The source code for CI Pipeline is present in **simple-vsi-app-toolchain-\* > .build_pipeline** folder.

| Task Name | Description |  Location |
|--|--|--|
| build-source| Task to compile the Application Source Code | pipeline.yaml |
| unit-tests | Task to run the unit tests and copy the report type and location as result of the task| pipeline.yaml |
| code-coverage | Task to run the code coverage and copy the report type and location as result of the task | pipeline.yaml | 
| package-build-artifacts | Task to package the artifact as (.jar/.zip/.tar.gz) | pipeline.yaml |
| build-artifacts-info | Task to build the artifact metadata information | task.yaml |

##### Modify the Continous Deployment Pipeline task
The CD Pipeline is responsible for copying the application artifact ( .jar/.zip/.tar.gz) format to the deployment environment. Users can modify the existing tasks for deploying, restarting the applications based on the system/application environments. The source code for CD Pipeline is present in **simple-vsi-app-toolchain-\* > .deploy_pipeline** folder.

| Task Name | Description |  Location |
|--|--|--|
| deploy-script | Task to create script to run on target environment to perform deployment | task.yaml |
| backup-script | Task to create script to run on target environment to backup last deployment| task.yaml |
| deploy | Task to connect to remote target environment and run the deployment script | task.yaml | 
| health-check-task | Task to perform health check on deployed application | task.yaml |
| acceptance-test | Task to run the acceptance tests on the deployed application | task.yaml |
|roll-back-deployment| Task to rollback deployment to last state incase of failures| task.yaml |



### Learn more

*  [Getting started with toolchains](https://cloud.ibm.com/devops/getting-started)

*  [Documentation](https://cloud.ibm.com/docs/services/ContinuousDelivery?topic=ContinuousDelivery-getting-started&pos=2)