import requests
import json
from datetime import datetime

# Define the URL of the endpoint
url = 'http://localhost:8080/CrossSell/emit'

# Construct the JSON payload
payload = {
    "loyaltycardid": 123456,
    "purchases": [
        {
            "id": 1,
            "timestamp": datetime.now().isoformat(),
            "price": 100.50,
            "product": "Laptop",
            "supplier": "TechStore",
            "shop_name": "BestBuy",
            "loyaltyCard_id": 123456
        },
        {
            "id": 2,
            "timestamp": datetime.now().isoformat(),
            "price": 22.30,
            "product": "Mouse",
            "supplier": "ComputerPartsCo",
            "shop_name": "BestBuy",
            "loyaltyCard_id": 123456
        }
    ]
}

# Convert the Python dictionary to a JSON string
json_data = json.dumps(payload)

# Send the POST request
response = requests.post(url, headers={'Content-Type': 'application/json'}, data=json_data)

# Print the response from the server
print(f"Response Status Code: {response.status_code}")
print(f"Response Text: {response.text}")
