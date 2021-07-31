# Checkmark.dev

## Requirements

To run the project, you'll need:

- Docker (>= v20 recommended) & docker-compose
- Make
## Installation

Before running the project, make sure you have the env files setup.

```sh
make setup-env
```

Once setup, to start the project locally, run:

```sh
docker-compose up -d
```

This will start all the required parts of the project. Once it's done, you can access the website under `http//localhost:8080`.

## Deployment

The project is deployed in production with Kubernetes.

To deploy in production, we merge in `master` and a Github Action will handle the deployment with `devspace`.

Devspace is a tool to simplify the Kubernetes configuration. You can see how it's done in the `devspace.yml` file.

## Contributing

This project is split between different apps. You can learn more about each one in their respective README file.

## License

MIT.
