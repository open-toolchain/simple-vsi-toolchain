# Develop a Simple Java Application and Deploy on Virtual Server (Virtual Machine)
### Continuously Deliver a Java Application to the Virtual Server Instance.

By following this tutorial, you can create an open toolchain, and then use the toolchain and DevOps practices to develop a simple "Hello World" Java web application that you deploy to the IBM Cloud® Virtual Server Instance.

This Simple Java application exposes an HTTP Endpoint at port 8080 of the host machine to present a Hello World Greeting message at the /v1/ HTTP Path. The application utilizes a maven build system to provide build and test capability. The application comes preconfigured for a DevOps toolchain that provides continuous delivery with source control, issue tracking, online editing, and deployment to the IBM Virtual Server Instance. 

The application code is stored in the application source control repository whereas the build and deploy scripts are stored in the pipeline source control repository. The build and deploy scripts can be customized to suit the development needs of the application.

The toolchain implements the following best practices:
- Builds application binary on every Git commit, sets a tag based on build number, timestamp, and commit id for traceability
- Inserts the built binary into the deployment manifest automatically.
- Creates IBM Cloud Storage Instance and Bucket to store the intermittent build binaries out-of-box. For advanced users, the IBM Cloud Storage Instances and Buckets to store binaries can be customized to utilize existing resources.
- For advanced users with versioning requirements for the build binaries, the toolchain supports TaaS based artifactory (for IBM account users) as artifact store. An existing artifactory repository can be configured and integrated with the toolchain to support the versioning of these build artifacts.


# ![Icon](https://github.com/open-toolchain/simple-vsi-toolchain/blob/master/.bluemix/images/toolchain.png)

---
### Prerequisites:

- **Virtual Server Instance** - 
This toolchain requires a Virtual Server Instance running in IBM Cloud. If you don't have one, then you need to [create a Virtual Server Instance](https://cloud.ibm.com/docs/vpc?topic=vpc-creating-virtual-servers) in IBM Cloud which serves as the target host where the Java Application should be deployed.   

    *   The Virtual Server Instances needs to have a Floating IP that is accessible over the public internet. More instructions on using a Floating IP with your instances can be found [here](https://cloud.ibm.com/docs/vpc?topic=vpc-creating-a-vpc-using-the-ibm-cloud-console#reserving-a-floating-ip-address)

    * The toolchain connects to the Virtual Server Instance Secure Shell (SSH) to carry out the deployment task. Please make sure that the Security Group assigned to the Virtual Server Instance Inbound rules to allow access to the port (default: 22) at which SSH service listens to incoming SSH requests. More instructions on configuring Security Groups for Virtual Server Instance can be found [here](https://cloud.ibm.com/docs/security-groups?topic=security-groups-getting-started).

    * The toolchain needs the login credentials, preferably of a non-privileged user, to connect to the Virtual Server Instance to deploy and run the built application binaries. The toolchain supports credentials in the form of Username/Password or Username/SSH-Keys combination. Refer to [detailed instructions](https://cloud.ibm.com/docs/vpc-on-classic-vsi?topic=vpc-on-classic-vsi-ssh-keys#ssh-keys) on how to create SSH keys for a given user account..

    * The toolchain performs health check of the deployed application. It is required to add a inbound rule for `TCP` allow port `8080` so that application endpoint can be accessed. More information can be found [here](https://cloud.ibm.com/docs/security-groups?topic=security-groups-managing-sg)

Note: 
1. If you are providing SSH private key as credentials, convert the SSH key into `base64`, as explained later in this article. 
      
2. If you are providing Username and Password, enable `PasswordAuthentication` in the Virtual Server Instance. More information can be found [here](https://www.computernetworkingnotes.com/rhce-study-guide/how-to-configure-ssh-server-in-redhat-linux.html)

### Advanced User Scenarios:

Any change to the source triggers the CI Pipeline. The result of a successful CI Run is a new build/binary artifact which is stored first to an intermediate storage and then deployed to the target Virtual Server Instance. The toolchain provides user with an option to use either IBM Cloud Object Store or Artifactory as an intermediate storage to store the build binaries.

 - **Cloud Object Store (Default)** -  The toolchain leverages the IBM Cloud Store to archive intermediate application build binaries. In case user does not have an instance of IBM Cloud Object Store, the toolchain creates one on behalf of user. The toolchain then creates a bucket to store all the built application binaries. In cases when user intends to use an existing instance of IBM Cloud Store and Bucket, user can configure the toolchain to utilize the same. More instructions on creating an instance of Cloud Object Store can be found [here](https://cloud.ibm.com/docs/cloud-object-storage/basics?topic=cloud-object-storage-provision)

 - **Artifactory (Optional)** - The toolchain provides the capability to utilize an existing instance of JFrog Artifactory as a storage for the build/binary artifacts (for ex. jar, exe).  This TaaS-based Artifactory instance is accessible only with valid IBM credentials. Refer to the TaaS Guide https://taas.cloud.ibm.com/guides#artifactory 
Please note: 
	 - If artifactory is configured and integrated then artifactory is used as intermediate build storage.
	 - If the COS bucket name is configured then corressponding bucket is used as intermediate build storage.
	 - If neither Artifatory nor COS bucket name is configured, then toolchain creates a COS instance in the default resource group. Once a COS Instance is successfully created, toolchain creates a bucket within the newly created COS Instance and use the same for storing artifacts.
---

### To get started, click this button:
[![Create toolchain](https://cloud.ibm.com/devops/graphics/create_toolchain_button.png)](https://cloud.ibm.com/devops/setup/deploy?repository=https://github.com/open-toolchain/simple-vsi-toolchain.git&env_id=ibm:yp:us-south&pipeline_type=tekton)

---
### Steps
1. On the Create Page, please provide inputs for mentioned fields
    - Toolchain Name - Unique name to identify your toolchain
    - Region - Select the region where you want to deploy your toolchain (Ex: us-south)

![Toolchain Details](https://github.com/open-toolchain/simple-vsi-toolchain/blob/master/.bluemix/docs-images/toolchain-header.png)

### App Repository Configurations

![Toolchain Details](https://github.com/open-toolchain/simple-vsi-toolchain/blob/master/.bluemix/docs-images/app-repo.png)

### Inventory Repository Configurtaion
1. Inventory repo is used to store the metadata of the builds and artifacts. 
2. Commit on the Inventory repo triggers the CD pipeline to deploy the artifacts on the VSI and do the acceptance task.

![Toolchain Details](https://github.com/open-toolchain/simple-vsi-toolchain/blob/master/.bluemix/docs-images/inventory-repo.png)

### Delivery Pipeline Configurations
2. On the Create Page, please navigate to the "Delivery Pipeline" Tab and fill in details:
    1. IBM Cloud API Key - Use an existing Key or create a new key. This key is used by the toolchain to interact with other Cloud Service integrated into the toolchain.
    2. Virtual Server Instance Region - Region where Virtual Server Instance is running. (Ex. us-south)
    3. Virtual Server Instance - Floating IP Address of the Virtual Server Instance. (Ex. aaa.bbb.ccc.ddd)
    4. Authentication Type - User Credentials / SSH Key.  
        - User Credentials: 
            - User Name - Username of the Virtual Server Instance user with permission to deploy and run the application.
            - Password - Password of the Virtual Server Instance user with permission to deploy and run the application.
        - SSH Credentials:
            - User Name - Username of the Virtual Server Instance user with permission to deploy and run the application.
            - SSH KEY - Private SSH Key (base64 encoded) of the user to deploy and run the application.
        
Please run below commands create a new key-pair on the Virtual Server Instance for the user with permission to deploy and run the applications.
```
        # Create the SSH key
            ssh-keygen -C cloud.ibm.com
        # copy public it to the VSI  
            ssh-copy-id -i .ssh/id_rsa.pub <UserName>@<xx.yy.zz.aa>
        # Encode the key in base64 format
            echo $(cat .ssh/id_rsa | base64 -w 0) #for linux environment
            echo $(cat .ssh/id_rsa | base64 -b 0) #for mac users:
```
![Virtual Server Instance Details](https://github.com/open-toolchain/simple-vsi-toolchain/blob/master/.bluemix/docs-images/Deliver-pipeline.png)
### More Tool configurations: 
1. Cloud Object Storage (Advanced User Scenarios) - For users who with an existing Cloud Object Store Instance to store intermediate build artifacts,  please navigate to the "More Tools" Tab and fill in details about your Cloud Object Store Instance:
    - Bucket Name in your Cloud Object Storage Instance - Provide the name of the bucket where you wish to store the intermediate build artifacts. If you are providing the bucket name, please ensure that you are creating the bucket in the same region where the toolchain is created. Else pipeline will not be able to upload the objects to the bucket.
![Cloud Object Storage Integration Details](hhttps://github.com/open-toolchain/simple-vsi-toolchain/blob/mmaster/.bluemix/docs-images/COS-conf.png)

2. Artifactory (Advanced User Scenarios) - For users with valid IBM Credentials and TaaS based artifactory account to store intermediate build artifacts, please navigate to the "More Tools" Tab and fill in details about your Artifactory Instance:
    1. Artifactory Server URL - HTTP URL of the Artifactory Server 
    2. Type - Choose from (npm/maven/docker)    
    3. Artifactory UserID - UserID to login to the Artifactory Server (Ex. xxx.xxx@ibm.com)
    4. Artifactory APIKey - APIKey generated by the User (Existing/New) 
    5. Release URL - Release URL for the artifactory repo where artifacts are to be stored 

#### Note: Some fields in the artifactory are mandatory only when you do the artifactory configuration.    
![Artifactory Integration Details](https://github.com/open-toolchain/simple-vsi-toolchain/blob/master/.bluemix/docs-images/Artifactory-conf.png)
### Learn more 
* [Getting started with toolchains](https://cloud.ibm.com/devops/getting-started)
* [Documentation](https://cloud.ibm.com/docs/services/ContinuousDelivery?topic=ContinuousDelivery-getting-started&pos=2)

### Additional Information
#### How to role back to one of previous version of deployed application?

1. if you want to revert your current version and install last version of the application then we can make use of inventory repo.

   1. `git clone <inventory-repo-url>` clone the inventory repo from your pipeline. This will download entire git repo. We will assume that CD-Pipeline is listening to master branch of the inventory repo.
   2. `git log` will provide you list of commits that has been done by CI pipeline.
   3. `git checkout master` will checkout to master branch.
   4. `lastCommitID=$(git log --format="%H" -n 1)` will get the last commit ID of the repo.
   5. `git revert $lastCommitID` will create a new commit by reverting the current change. Make sure that you provide a commit message for this revert.
   6. `git push` will push the change to inventory repo. This will initiate the CD-pipeline for application deployment.
2. if you want to role back your current version and install a previous version of the application then we can make use of inventory repo.
      
   1. `git clone <inventory-repo-url>` Clone the inventory repo from your pipeline. This will download entire git repo. We will assume that CD-Pipeline is listening to master branch of the inventory repo. 
   2. `git log` will provide you list of commits that has been done by CI pipeline. identify the `commit id` which you are targeting for the application deployment.
   3. `git reset --hard shaCommit .` will revert the changes in your working directory. 
   4. `git push origin master --force` will push the change to inventory repo. This will initiate the CD-pipeline for application deployment.

#### GitOps flow

This section walks through a workflow, Where a CD pipeline will be triggered only when a pull request/commit to a specific branch of inventory Repo takes place.

1. Create a Toolchain in IBM Cloud for VSI Instance by providing VSI instance, Application Repo, COS etc... details.
2. Once the toolchain is created, Click on the Inventory repo and create multiple branches(Prod, Staging and DEV).
3. Click on the CD Pipeline and go to triggers. Add a trigger with source as Inventory Repo with the branch which you want to trigger the CD-Pipeline(Master).
4. Now modify your CI pipeline to commit to respective inventory repo after successful integration.
5. Once there are sufficient number of commits are available in inventory repo. raise the pull request in inventory repo to master.
6. Now your CD Build be initiated. 

