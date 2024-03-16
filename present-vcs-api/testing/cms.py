import requests

# Replace these with your actual Directus credentials and URL
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


# Authentication
try:
    token = authenticate_directus(directus_url, email, password)
    print("Authentication successful. Token:", token)

    # Define the data for the new item with the specific structure
    item_data = {
        "id": "vc-1",
        "type": "AllergyRecord",
        "issue_date": "",  # Fill in the issue date if required
        "content": {
            "allergy_code": "A001",
            "allergy_description": "Pollen Allergy",
            "reaction_code": "R102",
            "severity": "High"
        }
    }

    # Create item in the 'vcs' collection
    created_item = create_item_in_collection(token, directus_url, "vcs", item_data)
    print("Item created successfully:", created_item)
except Exception as e:
    print(e)
