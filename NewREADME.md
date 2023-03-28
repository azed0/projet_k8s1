A/ Applicants: image===> azed01/k8s:applicants, Service===> applicants-service

B/ Identity: image==> azed01/k8s:identity, Service===> identity-service

C/ Jobs: image==> azed01/k8s:jobs, Service===> jobs-service

D/ Database: image==> azed01/k8s:database, Service==> database-service

E/ Web: image==> azed01/k8s:web, Service==> web-service

F/ Redis: image==> redis:latest, Service==> redis-service

J/ Rabbitmq: image==> rabbitmq:3-management, Service===> rabbitmq-service

--------------------------------------------------------------------------------
 Ingress:

    # helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    # helm repo update
    # helm install nginx-ingress ingress-nginx/ingress-nginx --namespace myingress --set controller.replicaCount=2
------------------------------------------------------
Bilan de santé + ELK (elsaticsearch, logstach, kibana)

Bilan de santé:

Metrics Server:

        installer Metrics server: 
                kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
       
Kube State Metrics:

         installer Kube State Metrics:
                helm install kube-state-metrics stable/kube-state-metrics --namespace appscore
        
Prometheus:

        installer prometheus:
                helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
                helm repo update
                helm install my-prometheus prometheus-community/prometheus --set server.service.type=LoadBalancer --set rbac.create=false
       
Grafana:

        installer grafana:
                helm repo add grafana https://grafana.github.io/helm-charts
                helm repo update
                helm install my-grafana grafana/grafana --set service.type=LoadBalancer --set rbac.create=false
--------------------------------------------------------------------------
ELK:

Elasticsearch:
        
        installer Elasticsearch:
                helm repo add elastic https://helm.elastic.co
                helm install elasticsearch elastic/elasticsearch --version 7.10.0 --namespace appscore --set service.type=LoadBalancer

Logstash:
        
        installer Logstash:
                helm install logstash elastic/logstash --version 7.10.0 --namespace=appscore --set service.type=LoadBalancer

Kibana:

        installer Kibana:
            helm install kibana elastic/kibana --version 7.10.0 --namespace appscore --set service.type=LoadBalancer
--------------------------------------------------------------------------------------

Sécurité: 
    
Certificat SSL:

        #Créer une clé privée
            openssl genrsa -out tls.key 2048
        #Signature du certificat
            openssl req -new -key tls.key -out tls.csr
        #Certificat auto-signé 
            openssl x509 -req -days 365 -in tls.csr -signkey tls.key -out tls.crt
Secret Kubernetes:
        
        kubectl create secret tls tls-appscore --cert=tls.crt --key=tls.key --namespace=appscore
