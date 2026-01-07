import time

# cache structure:
# {
#   "flutter": {
#       "timestamp": 123456789,
#       "data": {...}
#   }
# }

_CACHE = {}
CACHE_TTL = 60 * 60  # 1 hour


def get_cached(tag: str):
    cached = _CACHE.get(tag)
    if not cached:
        return None

    # check expiration
    if time.time() - cached["timestamp"] > CACHE_TTL:
        _CACHE.pop(tag, None)
        return None

    return cached["data"]


def set_cache(tag: str, data):
    _CACHE[tag] = {
        "timestamp": time.time(),
        "data": data,
    }
def clear_cache():
    _CACHE.clear()
