from dotenv import load_dotenv
import os
import requests
import json
import pandas as pd

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

 
df = pd.json_normalize(r.json()['businesses'])
df.to_csv('.\data\data.csv')
