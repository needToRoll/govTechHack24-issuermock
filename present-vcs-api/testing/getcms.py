import requests

# Directus credentials and URL
directus_url = "https://directustesting.proudcoast-33470e41.switzerlandnorth.azurecontainerapps.io"
email = "admin@admin.com"
password = "d1r3ctu5"


def authenticate_directus(directus_url, email, password):
    """Authenticate with Directus and return the access token."""
    auth_endpoint = f"{directus_url}/auth/login"
    payload = {"email": email, "password": password}
    headers = {"Content-Type": "application/json"}
    response = requests.post(auth_endpoint, json=payload, headers=headers)
    if response.status_code == 200:
        data = response.json()
        return data['data']['access_token']
    else:
        raise Exception("Authentication failed", response.text)


def fetch_example_item_from_collection(token, directus_url, collection_name):
    """Fetch an example item from a specified collection."""
    fetch_endpoint = f"{directus_url}/items/{collection_name}"
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.get(fetch_endpoint, headers=headers)
    if response.status_code == 200:
        data = response.json()
        return data['data'][0] if data['data'] else None
    else:
        raise Exception("Failed to fetch item", response.text)


# Main execution
if __name__ == "__main__":
    try:
        token = authenticate_directus(directus_url, email, password)
        print("Authentication successful. Token obtained.")

        example_item = fetch_example_item_from_collection(token, directus_url, "vcs")
        if example_item:
            print("Example item fetched successfully:")
            print(example_item)
        else:
            print("No items found in the 'vcs' collection.")
    except Exception as e:
        print(e)
