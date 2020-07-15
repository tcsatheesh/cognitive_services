COGNITIVE_SERVICE_NAMESPACE=cogsvcs
kubectl create namespace $COGNITIVE_SERVICE_NAMESPACE
#create a secret
kubectl create secret docker-registry cogsvc-acr-secret --namespace $COGNITIVE_SERVICE_NAMESPACE \
--docker-server=https://containerpreview.azurecr.io \
--docker-username=$CONTAINER_PREVIEW_USERNAME \
--docker-password=$CONTAINER_PREVIEW_PASSWORD

helm install \
    --set cognitive_service_api_key=$COGNITIVE_SERVICE_API_KEY \
    cvocr cvocr -n $COGNITIVE_SERVICE_NAMESPACE
helm install \
    --set cognitive_service_api_key=$COGNITIVE_SERVICE_API_KEY \
    cvread cvread -n $COGNITIVE_SERVICE_NAMESPACE

openssl req -x509 -nodes -days 730 -newkey rsa:2048 \
    -keyout labeltool-ingress-tls.key \
    -out labeltool-ingress-tls.crt \
    -config req.cnf

kubectl create secret tls labeltool-ingress-tls \
-n $COGNITIVE_SERVICE_NAMESPACE \
--key labeltool-ingress-tls.key \
--cert labeltool-ingress-tls.crt


helm upgrade --install \
    labeltool labeltool -n $COGNITIVE_SERVICE_NAMESPACE
