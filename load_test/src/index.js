import { check } from 'k6'
import { SharedArray } from 'k6/data'
import { Trend } from 'k6/metrics'
import { connect, close, publish } from 'k6/x/mqtt'
import { scenario } from 'k6/execution'

const sharedData = new SharedArray('some data name', function () {
  return JSON.parse(open('./data.json'))
})

const connections = {}

const timeout = 2000 // in ms

const publish_trend = new Trend('publish_time', true)

const host = 'localhost'
const port = '1883'

export const options = {
  scenarios: {
    'default': {
      executor: 'shared-iterations',
      vus: 10,
      iterations: sharedData.length,
      maxDuration: '1h',
    },
  },
};

export default function () {
    const data = sharedData[scenario.iterationInTest]

    const topic = `vital_signs/${data.user_id}`
    const topicMessage = JSON.stringify(data)

    const publisherId = `k6-pub-${__VU}`

    let connectionError, publisherClient

    if (publisherId in connections) {
        publisherClient = connections[publisherId]
    } else {
        try {
            publisherClient = connect(
                // list of URL of  MQTT server to connect to
                [host + ':' + port],
                // username
                '',
                // password
                '',
                // clean session setting
                false,
                // client id
                publisherId,
                // timeout in ms
                timeout
            )

            connections[publisherId] = publisherClient
        } catch (error) {
            connectionError = error
        }
    }

    check(connectionError, {
        'is pub connected': (err) => err === undefined,
    })

    let publishError
    let startTime = new Date().getTime()
    try {
        publish(
            // producer object
            publisherClient,
            // topic to be used
            topic,
            // the QoS of messages
            1,
            // message to be sent
            topicMessage,
            // retain policy on message
            false,
            // timeout in ms
            timeout
        )

        publish_trend.add(new Date().getTime() - startTime)
    } catch (error) {
        publishError = error
    }

    check(publishError, {
        'is sent': (err) => err === undefined,
    })
}

export function teardown() {
    for (const client in connections) {
        close(client, timeout)
    }
}
