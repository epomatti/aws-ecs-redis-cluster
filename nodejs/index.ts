import 'dotenv/config'
import express from 'express';
import { Queue, Worker } from 'bullmq';


(async () => {
  try {
    require('dotenv').config();

    const PORT = process.env.PORT;
    const REDIS_HOST = process.env.REDIS_HOST;
    const REDIS_PORT = Number(process.env.REDIS_PORT);
    const REDIS_CONNECT_TIMEOUT = Number(process.env.REDIS_CONNECT_TIMEOUT);
    const REDIS_PASSWORD = process.env.REDIS_PASSWORD;
    const REDIS_TLS = process.env.REDIS_TLS;

    const app = express();
    const port = PORT ? Number(PORT) : 3000;

    const tls = REDIS_TLS === "1" ? {} : undefined;
    const queueName = "test-queue"

    const myQueue = new Queue(queueName, {
      connection: {
        host: REDIS_HOST,
        port: REDIS_PORT,
        connectTimeout: REDIS_CONNECT_TIMEOUT,
        password: REDIS_PASSWORD ? REDIS_PASSWORD : undefined,
        tls: tls
      }
    });

    const myWorker = new Worker(queueName, async (job) => { console.log(job.data) }, {
      connection: {
        host: REDIS_HOST,
        port: REDIS_PORT,
        connectTimeout: REDIS_CONNECT_TIMEOUT,
        password: REDIS_PASSWORD,
        tls: tls
      }
    });

    app.get('/', (req, res) => {
      res.send('OK')
    })

    app.post('/enqueue', async (req, res) => {
      await myQueue.add('myJobName', { foo: 'bar' });
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

