# projet_k8s

1/ Déploiement de pods =

    A/ Applicants: image===> azed01/k8s:applicants, Service===> applicants-service

    B/ Identity: image==> azed01/k8s:identity, Service===> identity-service

    C/ Jobs: image==> azed01/k8s:jobs, Service===> jobs-service

    D/ Database: image==> azed01/k8s:database, Service==> database-service

    E/ Web: image==> azed01/k8s:web, Service==> web-service

    F/ Redis: image==> redis:latest, Service==> redis-service

    J/ Rabbitmq: image==> rabbitmq:3-management, Service===> rabbitmq-service

2/Bilan de santé =
    
    #instaler les metrics-server
        kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
        helm install kube-state-metrics prometheus-community/kube-state-metrics
    #installer prometheus
         helm install stable/prometheus --name my-prometheus --set server.service.type=LoadBalancer --set rbac.create=false
    #récupérer l'@ IP
        kubectl get svc -n appscore
    #Vérification de la configuration du prometheus dans: 
        kubectl exec -it <your-prometheus-server> -c prometheus-server -- cat /etc/config/prometheus.yml
    # Modification de la cible: 
        pour modifier la cible des métriques il faut récupérer ce code https://github.com/helm/charts/blob/master/stable/prometheus/values.yaml
            et modifier les cibles par le nom de service de notre application
    #Add and edit values.yaml
        helm upgrade my-prometheus stable/prometheus --set server.service.type=LoadBalancer --set rbac.create=false  -f prometheus.values.yaml
    #install grafana 
        helm install --name my-grafana stable/grafana --set service.type=LoadBalancer --set rbac.create=false


3/Sécurité =

    #Certificat auto-signé
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt
    #Créer un secret Kubernetes pour stocker les clés
        kubectl create secret tls my-tls-secret --key tls.key --cert tls.crt -n appscore
    #Ensuite Dans ignress on l'on rajoute : 
            apiVersion: networking.k8s.io/v1
            kind: Ingress
            metadata:
                name: my-ingress
                namespace: appscore
            annotations:
                 nginx.ingress.kubernetes.io/ssl-redirect: "true"
                 nginx.ingress.kubernetes.io/rewrite-target: /
                 nginx.ingress.kubernetes.io/use-regex: "true"
            spec:
                tls:
                    - hosts:
                        - example.com
                        secretName: my-tls-secret
4/Logs =
    Pour les logs on a choisi la pile EFK= Elasticsearch, Fluent, kibana
    
    #Elasticsearch: stocker indexer, les données en temps réel 
        helm install elasticsearch stable/elasticsearch
    
    #Fluent: collecte des logs open source
        récuperer le code : https://github.com/fluent/fluentd-kubernetes-daemonset/blob/master/fluentd-daemonset-elasticsearch.yaml
        kubectl create -f fluentd.yml
    #Kibana: explorer les données:
    files:
      kibana.yml:
        ## Default Kibana configuration from kibana-docker.
            server.name: kibana
            server.host: "0"
            ## For kibana < 6.6, use elasticsearch.url instead
            elasticsearch.hosts: http://elasticsearch:9200
        service:
            type: ClusterIP

        helm install kibana stable/kibana -f kibana-values.yaml


5/Déploiement automatisé =
