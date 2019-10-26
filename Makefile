CLUSTER_NAME ?= hasura-demo

bootstrap: cluster config metrics secrets deploy

cluster:
	doctl kubernetes cluster create ${CLUSTER_NAME}

config:
	doctl kubernetes cluster kubeconfig save ${CLUSTER_NAME}

deploy:
	kubectl apply -f manifest.yaml

metrics:
	git clone git@github.com:kubernetes/kube-state-metrics.git
	kubectl create -f kube-state-metrics/examples/standard/

remove:
	kubectl delete -f kube-state-metrics/examples/standard/
	kubectl delete secrets hasura-db-url
	kubectl delete -f manifest.yaml
	doctl kubernetes cluster delete ${CLUSTER_NAME}

secrets:
	kubectl create secret generic hasura-db-url --from-file=./.env
