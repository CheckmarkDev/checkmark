setup-env:
	cp apps/api/.env.example apps/api/.env
	cp apps/www/.env.example apps/www/.env
	cp apps/redis/.env.example apps/redis/.env
	cp apps/redis/redis.conf.example apps/redis/redis.conf
	cp apps/discord-bot/.env.example apps/discord-bot/.env
	cp apps/db/.env.example apps/db/.env

clear-secrets:
	kubectl delete secret www-secret
	kubectl delete secret api-secret
	kubectl delete secret redis-secret
	kubectl delete secret discord-bot-secret

create-secrets:
	kubectl create secret generic www-secret --from-env-file=./apps/www/.env.prod
	kubectl create secret generic api-secret --from-env-file=./apps/api/.env.prod
	kubectl create secret generic redis-secret --from-env-file=./apps/redis/.env.prod
	kubectl create secret generic discord-bot-secret --from-env-file=./apps/discord-bot/.env.prod
