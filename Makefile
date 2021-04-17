clear-secrets:
	kubectl delete secret www-secret
	kubectl delete secret api-secret
	kubectl delete secret redis-secret

create-secrets:
	kubectl create secret generic www-secret --from-env-file=./apps/www/.env.prod
	kubectl create secret generic api-secret --from-env-file=./apps/api/.env.prod
	kubectl create secret generic redis-secret --from-env-file=./apps/redis/.env.prod
