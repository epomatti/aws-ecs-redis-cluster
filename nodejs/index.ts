import 'dotenv/config'
import express from 'express';
import { Queue, Worker } from 'bullmq';


(async () => {
  try {
    process.on("uncaughtException", function (err) {
      console.error(err);
    });

    process.on("unhandledRejection", (reason, promise) => {
      console.error(reason);
    });

    require('dotenv').config();

    const PORT = process.env.PORT;
    const REDIS_HOST = process.env.REDIS_HOST;
    const REDIS_PORT = Number(process.env.REDIS_PORT);
    const REDIS_CONNECT_TIMEOUT = Number(process.env.REDIS_CONNECT_TIMEOUT);
    const REDIS_PASSWORD = process.env.REDIS_PASSWORD;
    const REDIS_TLS = process.env.REDIS_TLS;
    const PRIVATE_KEY = process.env.PRIVATE_KEY;

    const app = express();
    const port = PORT ? Number(PORT) : 3000;

    const tls = REDIS_TLS === "1" ? {} : undefined;
    const queueName = "test-queue"

    const queue = new Queue(queueName, {
      connection: {
        host: REDIS_HOST,
        port: REDIS_PORT,
        connectTimeout: REDIS_CONNECT_TIMEOUT,
        password: REDIS_PASSWORD ? REDIS_PASSWORD : undefined,
        tls: tls
      }
    });

    queue.on("error", (err) => {
      console.error(err);
    })

    const worker = new Worker(queueName, async (job) => { console.log(job.data) }, {
      connection: {
        host: REDIS_HOST,
        port: REDIS_PORT,
        connectTimeout: REDIS_CONNECT_TIMEOUT,
        password: REDIS_PASSWORD ? REDIS_PASSWORD : undefined,
        tls: tls
      }
    });

    worker.on("error", (err) => {
      console.error(err);
    })


    app.get('/', (req, res) => {
      res.send('OK')
    })

    app.get('/privatekey', (req, res) => {
      res.send(PRIVATE_KEY)
    })

    app.post('/enqueue', async (req, res) => {
      console.log("Adding to Redis queue...")
      await queue.add('myJobName', { foo: 'bar' });
      console.log("Adding to Redis queue: OK")
      res.send('OK')
    })

    app.get('/health', (req, res) => {
      res.send('OK')
    })

    app.listen(port, () => {
      console.log(`Example app listening on port ${port}`)
    })
  } catch (e) {
    console.error(e);
  }
})();

