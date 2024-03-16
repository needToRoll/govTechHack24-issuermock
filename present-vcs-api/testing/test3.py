import requests
from datetime import datetime

# Directus credentials and URL
directus_url = "https://directustesting.proudcoast-33470e41.switzerlandnorth.azurecontainerapps.io"
email = "admin@admin.com"
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

import uuid

def transform_payload(vcs_list):
    transformed_payload = {
        'vc': [
            {
                'id': vc['id'],
                'type': vc['type'],
                'issue_date': vc['issue_date'],
                'content': vc['content']
            } for vc in vcs_list
        ]
    }
    return transformed_payload

try:
    # Authenticate
    token = authenticate_directus(directus_url, email, password)
    print("Authentication successful. Token:", token)

    # Liste von VCs
    vcs_list = [
    {
        "id": "vc-1",
        "type": "AllergyRecord",
        "issue_date": datetime.now().isoformat(),
        "content": {
            "allergy_code": "A001",
            "allergy_description": "Pollen Allergy",
            "reaction_code": "R102",
            "severity": "High"
        }
    },
    {
        "id": "vc-2",
        "type": "MedicationRecord",
        "issue_date": datetime.now().isoformat(),
        "content": {
            "medication_code": "M002",
            "medication_name": "Aspirin",
            "dosage_instruction": "Take one tablet daily"
        }
    }
]

    # Transformiere die Liste der VCs
    json_output = transform_payload(vcs_list)

    # Erstelle den Eintrag in der 'vcs' Sammlung mit einer eindeutigen ID
    created_vc = create_item_in_collection(token, directus_url, "vcs", json_output)
    print(f"VC(s) created successfully: {created_vc}")

except Exception as e:
    print(e)