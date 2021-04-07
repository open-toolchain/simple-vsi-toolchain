# Your build script should go here.
# Existing template utilizes a Maven Based Java Application and hence the build steps utilizes maven mvn wrapper to build the Java Archive
# Incase your application is Java/Go based where the deployment unit comprises of a binary you may need to modify the lines below to cater
# to the needs of your build system. For interpreter based project (Python/JS), where the application needs only the source code, you may
# skip this step or comment out the existing lines and move over to copy the contents to /artifacts/binaries folder.
            
echo “Started building the binary image.”
mvn install -Dmaven.test.skip=true -Dmaven.repo.local=./m2/repository
echo “Finished building the binary image.”

# All the artifacts that your application needs for successful deployment ( for example: binary files, images, configuration files, source files
# in case of interperter based projects etc) must be copied over to /artifacts/binaries directory as is done below. In the existig Springboot
# application, the built Java Jar is a self-contained binary with embedded web server and hence does not need anything other than just the Jar.
# All the items placed in the /artifacts/binaries folder will be picked up by subsequent step to be uploaded either to Artifactory/IBM Cloud Object Storage
# based on your selection during toolchain creation.

mkdir binaries
cp -r target/* binaries
echo “Copied the artifacts to the uploads folder.”
