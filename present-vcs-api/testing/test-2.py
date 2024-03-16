import requests
from datetime import datetime

# Directus credentials and URL
directus_url = "http://localhost:8055"
email = "admin@example.com"
password = "d1r3ctu5"

def authenticate_directus(directus_url, email, password):
    auth_endpoint = f"{directus_url}/auth/login"
    payload = {
        "email": email,
        "password": password
    }
    headers = {
        "Content-Type": "application/json"
    }
    response = requests.post(auth_endpoint, json=payload, headers=headers)
    if response.status_code == 200:
        data = response.json()
        return data['data']['access_token']
    else:
        raise Exception("Authentication failed", response.text)

def create_item_in_collection(token, directus_url, collection_name, item_data):
    create_endpoint = f"{directus_url}/items/{collection_name}"
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    response = requests.post(create_endpoint, json=item_data, headers=headers)
    if response.status_code in [200, 201]:
        data = response.json()
        return data['data']
    else:
        raise Exception("Failed to create item", response.text)

try:
    # Authenticate
    token = authenticate_directus(directus_url, email, password)
    print("Authentication successful. Token:", token)

    # The structured data to be transformed and created in the 'vcs' collection
    json_output = {
        'id': 18,  # This seems like a static value, ensure it's correctly generated or incremented if needed.
        'date_created': datetime.now().isoformat(),
        'vc': [
            {
                'id': 'hdhdahd',
                'type': 'Medication',
                'issue_date': '2025',  # This is a static value, adjust accordingly.
                'content': {
                    'diagnosisCode': 'J45',
                    'diagnosisDescription': 'Asthma'
                }
            }
        ]
    }

    # Creating the item in the 'vcs' collection
    created_vc = create_item_in_collection(token, directus_url, "vcs", json_output)
    print(f"VC created successfully: {created_vc['id']}")

except Exception as e:
    print(e)
