const axios = require('axios')

const MATTERMOST_WEBHOOK_URL = process.env.MATTERMOST_WEBHOOK_URL

exports.handler = async (event) => {
  for (const { Sns } of event.Records) {
    const { Message: message } = Sns
    await axios.post(MATTERMOST_WEBHOOK_URL, { text: message })
  }
}
