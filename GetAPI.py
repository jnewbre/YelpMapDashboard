import requests
from dotenv import load_dotenv
import os
import json

load_dotenv()

url = 'https://api.yelp.com/v3/businesses/search'

headers = {
    'Authorization': 'Bearer' + ' ' + os.environ['APIKey'],
    'Accept': 'application/json'
}

params = {
    'location': 'NYC',
    'term': 'food',
    'locale': 'en_US',
    'attributes': ['hot_and_new']
}

r = requests.get(
    url, 
    params=params, 
    headers = headers
)

r.json()

