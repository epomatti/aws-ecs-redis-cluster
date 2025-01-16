# AWS ECS Fargate + ElastiCache Redis

ElastiCache Redis deployment being accessed by an application running on ECS Fargate:

<img src=".assets/redis.png" width=800 />

## Running on AWS

Create the `.auto.tfvars` variables file:

```shell
cp aws/config/local.auto.tfvars aws/.auto.tfvars
```

Apply the resources:

```sh
terraform -chdir="aws" init
terraform -chdir="aws" apply -auto-approve
```

After the deployment, test the enqueue mechanism. Check CW Logs for the results:

```sh
curl -X POST http://lb-supercache-0000000000.us-east-2.elb.amazonaws.com/enqueue
```

The Redis instance is configured with encryption in transit and password authentication.


## Localhost

In order to test the application locally, run a Redis container:

```sh
docker run -d --name redis-local -p 6379:6379 redis
```

In the application directory, create the `.env` file for local development:

```sh
PORT="3000"
REDIS_HOST="localhost"
REDIS_PORT="6379"
REDIS_CONNECT_TIMEOUT="5000"
REDIS_TLS="0"
```

Run the application:

```sh
npm install
npm run dev
```

Send a test message to the Redis queue:

```sh
curl -X POST localhost/enqueue
```
