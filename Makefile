CLUSTER_NAME ?= hasura

bootstrap: cluster config dashboard metrics secrets deploy

cluster:
	doctl kubernetes cluster create ${CLUSTER_NAME}

config:
	doctl kubernetes cluster kubeconfig save ${CLUSTER_NAME}

dashboard:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta4/aio/deploy/recommended.yaml

deploy:
	kubectl apply -f manifest.yaml

metrics:
	git clone git@github.com:kubernetes/kube-state-metrics.git
	kubectl create -f kube-state-metrics/examples/standard/

proxy:
	kubectl proxy

remove:
	kubectl delete -f kube-state-metrics/examples/standard/
	kubectl delete -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta4/aio/deploy/recommended.yaml
	rm -rf kube-state-metrics
	kubectl delete secrets ${CLUSTER_NAME}-secrets
	kubectl delete -f manifest.yaml
	doctl kubernetes cluster delete ${CLUSTER_NAME}

secrets:
	kubectl create secret generic ${CLUSTER_NAME}-secrets --from-file=./.env
