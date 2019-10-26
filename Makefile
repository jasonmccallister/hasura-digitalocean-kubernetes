secrets:
	kubectl create secret generic hasura-db-url --from-file=./.env

deploy:
	kubectl apply -f manifest.yaml

remove:
	kubectl delete secrets hasura-db-url
	kubectl delete -f manifest.yaml
