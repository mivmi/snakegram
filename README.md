# snakegram  
A Python library for Telegram

> This project is still a work in progress and not yet finished.

If you have any questions, ideas, or run into any issues, feel free to join the Telegram group and reach out:

[Telegram Group](https://t.me/SnakegramChat)

---

## Example

```python
from snakegram import filters, Telegram

client = Telegram(
    'session',
    api_id=1234567,
    api_hash='0123456789abcdef0123456789abcdef'
)

@client.on_update(
    filters.new_message
    & (filters.proxy.message.message.lower() == 'ping')
)
async def ping_handler(update):
    await client.send_text(
        update.message.peer_id,
        '*PONG*',
        reply_to=update.message
    )

client.start()
client.wait_until_disconnected()
```