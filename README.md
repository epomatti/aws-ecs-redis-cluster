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

In order to test the application locally, run a Valkey container:

```sh
docker run -d --name valkey-local -p 6379:6379 valkey/valkey
```

In the application directory, create the `.env` file for local development:

```sh
cp template.env .env
```

Run the application:

```sh
npm install
npm run dev
```

Send a test message to the Redis queue:

```sh
curl -X POST localhost:3000/enqueue
```

To test the private key from Secrets Manager:

```sh
curl localhost:3000/privatekey
```

To build the image locally:

```sh
docker build -t nodejs-app-local .
docker run 
```

## Secrets Manager

### Connect to the instance

In order to test this, SSM into the EC2 instance.

```sh
aws ssm start-session --target "<instance-id>"
```

Although the EC2 instance has been given permissions for simplicity in this example, you should use restricted permissions, preferably via [SSO](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sso.html):

> [!TIP]
> In the EC2 instance, you might have to use the legacy mode

```sh
aws configure sso
```

Check the identity:

```sh
aws sts get-caller-identity
aws configure list-profiles
```

### Create the private key passphrase

Perform this operation as the root:

```sh
sudo su -
```

Check your access to the private key passphrase secret:

```sh
aws secretsmanager describe-secret --secret-id "demo/private-key-password/xxxxx"
```

Define a secure passphrase:

```sh
touch passphrase.txt
chmod 600 passphrase.txt
pwgen -N 1 --secure 15 >> passphrase.txt
```

Set the secret value with a secure passphrase:

```sh
aws secretsmanager put-secret-value \
  --secret-id "demo/private-key-password/xxxxx" \
  --secret-string file://passphrase.txt
```

Shred and delete the file:

```sh
shred -zv passphrase.txt
rm -rf passphrase.txt
```

### Create the keys

Generate an RSA key pair:

```sh
# genrsa is deprecated and has been replaced by genpkey https://docs.openssl.org/master/man1/openssl-genpkey/
openssl genpkey -aes-256-cbc -algorithm RSA -out private-key.pem -pass file:passphrase.txt -pkeyopt rsa_keygen_bits:4096
openssl rsa -in private-key.pem -pubout -passin file:passphrase.txt -out public-key.pem
```

Test the private key with the passphrase:

```sh
openssl rsa -noout -in private-key.pem
```

To get the secret value from Secrets Manager for testing:

```sh
aws secretsmanager get-secret-value \
    --secret-id "demo/private-key/xxxxx" --query SecretString --output text
```

Some services may prefer to use DER format encoding:

```sh
openssl rsa -inform PEM -in private-key.pem -outform DER -out private-key.der
openssl rsa -pubin -inform PEM -in public-key.pem -outform DER -out public-key.der
```

Check the read access to the secret:

```sh
aws secretsmanager describe-secret --secret-id "demo/private-key/xxxxx"
```

Set the secret value with the private key material:

```sh
aws secretsmanager put-secret-value \
  --secret-id "demo/private-key/xxxxx" \
  --secret-string file://private-key.pem
```

Finally, don't forget to sign out of the SSO session and then destroy the resources:

```sh
aws sso logout
```
