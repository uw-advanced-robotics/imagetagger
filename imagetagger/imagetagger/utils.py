import re

def natural_sort(l, get_key): 
    convert = lambda text: int(text) if text.isdigit() else text.lower() 
    alphanum_key = lambda key: [ convert(c) for c in re.split('([0-9]+)', get_key(key)) ] 
    return sorted(l, key = alphanum_key)