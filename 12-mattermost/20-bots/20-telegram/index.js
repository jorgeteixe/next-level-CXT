const axios = require('axios')

const CHAT_ID = process.env.CHAT_ID
const TELEGRAM_TOKEN = process.env.TELEGRAM_TOKEN

exports.handler = async (event) => {
  for (const { Sns } of event.Records) {
    const { Message: message } = Sns
    await axios.get(`https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage?chat_id=${CHAT_ID}&text=${message}`)
  }
}
