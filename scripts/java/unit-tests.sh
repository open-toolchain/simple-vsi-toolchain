mvn -Dmaven.repo.local=./m2/repository clean test;
mkdir test-results
cp -r target/* test-results/
UNIT_TEST_RESULTS_LOC=./test-results/surefire-reports/*.xml
