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
