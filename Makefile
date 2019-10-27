CLUSTER_NAME ?= hasura

bootstrap: cluster config metrics

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
	rm -rf kube-state-metrics
	kubectl delete -f secrets.yaml
	kubectl delete -f manifest.yaml
	doctl kubernetes cluster delete ${CLUSTER_NAME}

secrets:
	kubectl apply -f secrets.yaml
