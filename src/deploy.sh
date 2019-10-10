COMPANY_NAME='sabancidx'
PROJECT_NAME='oslo'

TAG=v$(date '+%Y%m%d%H%M%S')

echo $TAG

docker build -t ${PROJECT_NAME}-web:$TAG ./web-frontend/

docker build -t ${PROJECT_NAME}-product:$TAG ./product-service/

docker build -t ${PROJECT_NAME}-user:$TAG ./user-service/

ACR_ID=`az acr show --name ${PROJECT_NAME}acr --resource-group $PROJECT_NAME-rg --query 'id' --output tsv`

ACR_LOGIN_SERVER=`az acr show --name ${PROJECT_NAME}acr --resource-group $PROJECT_NAME-rg --query 'loginServer' --output tsv`
ACR_USERNAME=`az acr show --name ${PROJECT_NAME}acr --resource-group $PROJECT_NAME-rg --query 'name' --output tsv`
ACR_PASSWORD=`az acr credential show --name ${PROJECT_NAME}acr --query 'passwords[0].value' --output tsv`

docker login $ACR_LOGIN_SERVER --username $ACR_USERNAME --password $ACR_PASSWORD

docker tag ${PROJECT_NAME}-web:$TAG $ACR_LOGIN_SERVER/${PROJECT_NAME}/${PROJECT_NAME}-web:$TAG
docker push $ACR_LOGIN_SERVER/${PROJECT_NAME}/${PROJECT_NAME}-web:$TAG

docker tag ${PROJECT_NAME}-product:$TAG $ACR_LOGIN_SERVER/${PROJECT_NAME}/${PROJECT_NAME}-product:$TAG
docker push $ACR_LOGIN_SERVER/${PROJECT_NAME}/${PROJECT_NAME}-product:$TAG

docker tag ${PROJECT_NAME}-user:$TAG $ACR_LOGIN_SERVER/${PROJECT_NAME}/${PROJECT_NAME}-user:$TAG
docker push $ACR_LOGIN_SERVER/${PROJECT_NAME}/${PROJECT_NAME}-user:$TAG

NAMESPACE=`kubectl get namespaces --output json | jq '.items[].metadata' | jq 'select(.name == "$PROJECT_NAME")' | jq --raw-output '.name'`

if [[ $NAMESPACE -eq '' ]]
then
  kubectl create namespace $PROJECT_NAME
fi

WEB_DEPLOYMENT=`kubectl get deployments --namespace=${PROJECT_NAME} --output=json | jq -r '.items[].metadata.name' | grep ${PROJECT_NAME}-web`
WEB_SERVICE=`kubectl get services --namespace=${PROJECT_NAME} --output=json | jq -r '.items[].metadata.name' | grep ${PROJECT_NAME}-web-service`

if [ $WEB_DEPLOYMENT == '' ]
then
  kubectl create deployment ${PROJECT_NAME}-web --image=$ACR_LOGIN_SERVER/${PROJECT_NAME}/${PROJECT_NAME}-web:$TAG --namespace=${PROJECT_NAME}
else
  kubectl set image deployment/${PROJECT_NAME}-web ${PROJECT_NAME}-web=$ACR_LOGIN_SERVER/${PROJECT_NAME}/${PROJECT_NAME}-web:$TAG --namespace=$PROJECT_NAME
fi

if [ $WEB_SERVICE == '' ]
then
  kubectl expose deployment ${PROJECT_NAME}-web --type=ClusterIP --name=${PROJECT_NAME}-web-service --port=80 --namespace=${PROJECT_NAME}
fi

PRODUCT_DEPLOYMENT=`kubectl get deployments --namespace=${PROJECT_NAME} --output=json | jq -r '.items[].metadata.name' | grep ${PROJECT_NAME}-product`
PRODUCT_SERVICE=`kubectl get services --namespace=${PROJECT_NAME} --output=json | jq -r '.items[].metadata.name' | grep ${PROJECT_NAME}-product-service`

if [ $PRODUCT_DEPLOYMENT == '' ]
then
  kubectl create deployment ${PROJECT_NAME}-product --image=$ACR_LOGIN_SERVER/${PROJECT_NAME}/${PROJECT_NAME}-product:$TAG --namespace=${PROJECT_NAME}
else
  kubectl set image deployment/${PROJECT_NAME}-product ${PROJECT_NAME}-product=$ACR_LOGIN_SERVER/${PROJECT_NAME}/${PROJECT_NAME}-product:$TAG --namespace=$PROJECT_NAME
fi

if [ $PRODUCT_SERVICE == '' ]
then
  kubectl expose deployment ${PROJECT_NAME}-product --type=ClusterIP --name=${PROJECT_NAME}-product-service --port=80 --namespace=${PROJECT_NAME}
fi

USER_DEPLOYMENT=`kubectl get deployments --namespace=${PROJECT_NAME} --output=json | jq -r '.items[].metadata.name' | grep ${PROJECT_NAME}-user`
USER_SERVICE=`kubectl get services --namespace=${PROJECT_NAME} --output=json | jq -r '.items[].metadata.name' | grep ${PROJECT_NAME}-user-service`

if [ $USER_DEPLOYMENT == '' ]
then
  kubectl create deployment ${PROJECT_NAME}-user --image=$ACR_LOGIN_SERVER/${PROJECT_NAME}/${PROJECT_NAME}-user:$TAG --namespace=${PROJECT_NAME}
else
  kubectl set image deployment/${PROJECT_NAME}-user ${PROJECT_NAME}-user=$ACR_LOGIN_SERVER/${PROJECT_NAME}/${PROJECT_NAME}-user:$TAG --namespace=$PROJECT_NAME
fi

if [ $USER_SERVICE == '' ]
then
  kubectl expose deployment ${PROJECT_NAME}-user --type=ClusterIP --name=${PROJECT_NAME}-user-service --port=80 --namespace=${PROJECT_NAME}
fi

INGRESS=`kubectl get ingress --namespace=${PROJECT_NAME} --output=json | jq -r '.items[].metadata.name'`

if [ $INGRESS == '' ]
then
  kubectl apply -f ./deploy.yml
fi
