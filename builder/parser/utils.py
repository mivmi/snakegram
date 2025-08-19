def get_position_info(content: str, position: int):
    """line number, index, line"""

    if position < 0:
        position = len(content) - 1

    line = ''
    lineno = 0
    counter = 0
    for line in content.splitlines():
        lineno += 1
        counter += len(line) + 1  # 1: \n char

        if counter >= position:
            break

    index = position - (counter - len(line))

    return lineno, index + 1, line.strip()
