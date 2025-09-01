# Snakegram  
⭐ Thank you to everyone who has supported Snakegram! Your stars help the project grow and improve.

Snakegram is a Python library for interacting with Telegram. It provides a simple, flexible interface to create bots, clients, and automated workflows with Python.

## Why Snakegram?

Working with MTproto can be complex. Snakegram handles all details for you, letting you focus on creating your app without worrying about the low-level work.


## Development Status

This library is actively being developed. New features are added frequently.  


## Installation

**Install the latest development version from GitHub:**  
```bash
pip install -U git+https://github.com/mivmi/snakegram.git@dev
```

**Install the last PyPI release (may not include recent changes):**
```bash
pip install snakegram
```

## Quick Start Example
```python

from snakegram import filters, Telegram

client = Telegram(
    'session',
    api_id=1234567,
    api_hash='0123456789abcdef0123456789abcdef'
)

# Handle incoming "ping" messages
@client.on_update(
    filters.new_message
    & ~ (
        filters.proxy.message.out
        |
        (filters.proxy.message % types.MessageService)
    )
    & filters.proxy.message.message.lower() == 'ping'
)
async def ping_handler(update):
    await client.send_message(update.message.peer_id, '*PONG*')

# start the client and keep it running
client.start()
client.wait_until_disconnected()

```
---

## Support & Community
Have questions or ideas? Join the discussion and get help in our Telegram group:

[Snakegram Chat](https://t.me/SnakegramChat)

## License
Snakegram is licensed under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0). See the [LICENSE](LICENSE) file for details.