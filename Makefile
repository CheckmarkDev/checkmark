clear-secrets:
	kubectl delete secret www-secret
	kubectl delete secret api-secret

create-secrets:
	kubectl create secret generic www-secret --from-env-file=./apps/front/.env.prod
	kubectl create secret generic api-secret --from-env-file=./apps/api/.env.prod
