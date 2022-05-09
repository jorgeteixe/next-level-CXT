const axios = require('axios')

const MATTERMOST_WEBHOOK_URL = process.env.MATTERMOST_WEBHOOK_URL

exports.handler = async (event) => {
  for (const { message } of event.Records) {
    await axios.post(MATTERMOST_WEBHOOK_URL, { text: message })
  }
}
