"""Input sanitization helpers."""
import re

_HTML_TAG_RE = re.compile(r'<[^>]+>')

def strip_html(text: str) -> str:
    """Remove HTML tags from a string."""
    if not text:
        return text
    return _HTML_TAG_RE.sub('', text)

def sanitize_quest_input(title: str, description: str) -> tuple[str, str]:
    """Sanitize quest title and description."""
    return strip_html(title.strip()), strip_html(description.strip())


def sanitize_guild_input(name: str, description: str) -> tuple[str, str]:
    """Sanitize guild name and description."""
    return strip_html(name.strip()), strip_html(description.strip())
