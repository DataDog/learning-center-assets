const tracer = require('dd-trace').init()
const express = require('express')
const winston = require('winston')
const bodyParser = require('body-parser')
const uuid = require('uuid/v4')
const sleep = require('sleep-promise')

const redis = require('redis')
const {promisify} = require('util')

const client = redis.createClient(process.env.REDIS_SERVICE_PORT, process.env.REDIS_SERVICE_HOST)

const logger = new (winston.createLogger)({
    transports: [
        new (winston.transports.Console)({
            name: 'user-api',
            json: true,
            level: 'info'
        })
    ]
});
client.on('connect', () => {
    logger.info('Redis client connected');
})

client.on('error', (err) => {
    logger.info('Couldn\'t connect to redis: ' + err)
})

const existsAsync = promisify(client.exists).bind(client)
const hgetallAsync = promisify(client.hgetall).bind(client)
const hmsetAsync = promisify(client.hmset).bind(client)
const keysAsync = promisify(client.keys).bind(client)

const users = [{'id': 1, 'name': 'City of Dorondo', 'uid': '123e4567-e89b-12d3-a456-426655440000', 'demand_gph': 110, 'users': 201},
                {'id': 2, 'name': 'Cortland County', 'uid': '223e4567-e89b-12d3-a456-625655440000', 'demand_gph': 210, 'users': 402},
                {'id': 3, 'name': 'C3 Energy', 'uid': '333e4567-c89b-12d3-a456-785655440000', 'demand_gph': 5000, 'users': 602}]

async function addUsers() {
    for (var user of users) {
        // only write user ids if users don't exist
        const exists = await existsAsync('user-' + user.uid)
        if (exists == 1) {
            logger.info('skipping ' + user.uid + ' as it exists')
        }
        else {
            logger.info('creating ' + user.uid)
            const created = await hmsetAsync('user-' + user.uid, {
                'id': user.id,
                'uid': user.uid,
                'name': user.name,
                'demand_gph': user.demand_gph,
                'users': user.users
            }) 
            logger.info(created)
        }
    }
}

addUsers()

const app = express()
app.use(bodyParser.json())

app.get('/', (req, res) => {
    res.json({'Hello from Water Usage': 'World!'})
})

app.get('/users', async (req, res) => {
    try {
        const userKeys = await keysAsync('user-*')
        var users = []

        const scope = tracer.scopeManager().active()
        const span = scope.span()
        
        const ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress

        span.addTags({
            'request-ip': ip
          })
        for (var userKey in userKeys) {
            user = await hgetallAsync(userKeys[userKey])
            users.push(user)
        }
        // await sleep(1000)
        await res.json(users)
    } catch (e) {
        res.sendStatus(500)
    }

})

app.post('/users', async (req, res) => {
    try {
        const userKeys = await keysAsync('user-*')
        const uid = uuid()
        const newUser = {
            'id': userKeys.length + 1,
            'uid': uid,
            'name': req.body.name,
            'demand_gph': req.body.demand_gph,
            'users': req.body.users
        }
        logger.info('creating ' + user.uid)
        const created = await hmsetAsync('user-' + uid, newUser) 
        return res.json({"user": newUser, "status": created})
    } catch (e) {
        logger.info(e)
        res.sendStatus(500)
    }
})

app.get('/users/:userId/', async (req, res) => {
    
    try {
        const userId = req.params.userId
        const user = await hgetallAsync('user-' + userId)
        logger.info('getting ' + user.uid)
        // await sleep(1000)
        return res.json(user)
    } catch (e) {
        logger.info(e)
        res.sendStatus(500)
    }
})

app.post('/users/:userId/concurrent-users/:userCount(\\d+)', async (req, res) => {
    try {
        const userCount = parseInt(req.params.userCount)
        const userId = req.params.userId

        const newStatus = await hmsetAsync('user-' + userId,
                                           {'users': userCount})
        const user = await hgetallAsync('user-'+ userId)
        await res.json(user)    
    } catch (e) {
        res.sendStatus(500)
    }
})

app.post('/users/:userId/water-level/:waterLevel(\\d+)', async (req, res) => {
    try {
        const waterLevel = parseInt(req.params.waterLevel)
        const userId = req.params.userId

        const newStatus = await hmsetAsync('user-' + userId,
                                           {'demand_gph': waterLevel})
        const user = await hgetallAsync('user-'+ userId)
        await res.json(user)    
    } catch (e) {
        res.sendStatus(500)
    }
})

app.listen(5004, () => logger.info('User demand API listening on port 5004!'))
