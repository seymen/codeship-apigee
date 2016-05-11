application=codeship
org=oseymen
environment=test
credentials=oseymen@gmail.com:ozzyozzy
url=https://api.enterprise.apigee.com

echo find . -name .DS_Store -print0 | xargs -0 rm -rf
find . -name .DS_Store -print0 | xargs -0 rm -rf

#un-deploy and delete the older version (version 1)
curl -u $credentials "$url/v1/organizations/$org/apis/$application/revisions/1/deployments?action=undeploy&env=$environment" -X POST -H "Content-Type: application/octet-stream"
curl -u $credentials -X DELETE "$url/v1/organizations/$org/apis/$application/revisions/1"

rm -rf $application.zip

#Make environment modifications
# sed -i '' 's/@lbserver1/morrisons-mock/' "./apiproxy/targets/default.xml"

#create bundle
zip -r $application.zip apiproxy

#import application
curl -v -u $credentials "$url/v1/organizations/$org/apis?action=import&name=$application" -T $application.zip -H "Content-Type: application/octet-stream" -X POST

#revert environment modifications
# sed -i '' 's/morrisons-mock/@lbserver1/' "./apiproxy/targets/default.xml"

#deploy application
curl -u $credentials "$url/v1/organizations/$org/apis/$application/revisions/1/deployments?action=deploy&env=$environment" -X POST -H "Content-Type: application/octet-stream"
