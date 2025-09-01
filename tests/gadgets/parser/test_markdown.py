from inspect import cleandoc
from snakegram.gadgets.parser import parse_markdown


def test_parse_markdown_escaped_chars():
    text = r'This is a \*literal asterisk\*'
    plain_text, entities = parse_markdown(text)

    assert entities == []
    assert plain_text == "This is a *literal asterisk*"


def test_parse_markdown_unclosed_markers():
    text = 'This is *not closed and _italic'

    plain_text, entities = parse_markdown(text)
    assert entities == []
    assert plain_text == text

def test_parse_markdown_precode():
    text = "```python\ndef __init__(self):\n\tprint('test')\n```"
    plain_text, entities = parse_markdown(text)

    assert plain_text == text[10:-4]

    assert len(entities) == 1
    entity = entities[0]

    assert entity.data == 'python'
    assert entity.type.name == 'PreCode'
