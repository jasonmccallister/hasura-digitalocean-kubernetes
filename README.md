# Installing Hasura on DigitalOcean Kubernetes

This project is a boilerplate to setup Hasura on Digital Ocean managed Kubernetes.

## Requirements

- `doctl`
- `kubectl`
- PostgreSQL - DigitalOcean Managed Database

## Setup

This project comes with a `bootstrap` command in the Makefile to perform the sets to go from zero to Hasura GraphQL. The `bootstrap` command will perform the following steps:

> Note: before running the command, ensure that you have created a PostgreSQL database and set the connection string in your `.env` file (see `.env.example` for more context)

- Create a new kuberenetes cluster by running `make cluster`
- Configure your local kubectl to talk to the newly created cluster
- Install kubernetes state metrics - used to get advanced insights on your Kubernetes cluster
- Create a `secret` to store your database credentials
- Deploy the Hasura application

> Note: this will also create a Digital Ocean Load Balancer to act as an ingress to your Hasura API.
