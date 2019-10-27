# Installing Hasura on DigitalOcean Kubernetes

This project is a boilerplate to setup Hasura on Digital Ocean managed Kubernetes.

## Requirements

- `doctl`
- `kubectl`
- PostgreSQL - DigitalOcean Managed Database

## Setup

This project comes with a `bootstrap` command in the Makefile to perform the sets to go from zero to Kubernetes! The `bootstrap` command will perform the following steps:

> Note: before running the command, ensure that you have created a PostgreSQL database and set the connection string in your `.env` file (see `.env.example` for more context)

- Create a new kuberenetes cluster by running `make cluster`
- Configure your local kubectl to talk to the newly created cluster using `make config`
- Install kubernetes state metrics - used to get advanced insights on your Kubernetes cluster by calling `make metrics`

### Creating Secrets

Most examples of `manifest.yaml` files for Kubernetes will store items like usernames and passwords in plaintext, this is a really bad practice! Luckily, Kubernetes ships with a secrets manager. In order to connect to the database, we need to grab the PostgreSQL connection string from the Digital Ocean managed database.

First, we need to `base64` sensitive information (items like enabling the console do not require being stored in a secrets manager).

```bash
echo -n 'postgresql://username:password@host:port/somedb' | base64
echo -n 'password' | base64
```

> Note: don't forget to remove `?sslmode=require` at the end of the string.

The first argument is the connection string for the database. The second line can be used for the admin console secret.

Now that those are `base64` encoded we can copy the `secrets.yaml` usign the following command:

```bash
cp secrets.example.yaml secrets.yaml
```

Change the default values in the `db` and `admin` keys in the newly created `secrets.yaml`. Let's create the secrets using:

```bash
make secrets
```

> Note: the main goal of this project is to go from zero to Hasura GraphQL, right now the secrets creation is a little rough. If you have a suggestion on how to make this better, please let me know or make a PR!

### Deploying Hasura

For the final step, its time to deploy Hasura! Most of the hard work was done ahead of time, now all that is left is to deploy!

```bash
make deploy
```

> Note: this will also create a Digital Ocean Load Balancer to act as an ingress to your Hasura API.

Login to your Digital Ocean control panel [https://cloud.digitalocean.com/networking/load_balancers](https://cloud.digitalocean.com/networking/load_balancers?i=7a9004&preserveScrollPosition=true) and you should have a newly created load balancer, grab the IP and visit your new GraphQL API powered by Hasura!
