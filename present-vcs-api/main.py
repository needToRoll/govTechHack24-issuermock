from fastapi import FastAPI, HTTPException
from typing import List, Union, Optional
from pydantic import BaseModel, ValidationError, Field
from datetime import datetime
import requests
import os

app = FastAPI()

# Use environment variables for sensitive information
directusUrl = os.getenv("DIRECTUS_URL", "https://directustesting.proudcoast-33470e41.switzerlandnorth.azurecontainerapps.io")
email = os.getenv("EMAIL", "admin@admin.com")
password = os.getenv("PASSWORD", "d1r3ctu5")

# Authentication function
def authenticateDirectus() -> str:
    authEndpoint = f"{directusUrl}/auth/login"
    payload = {"email": email, "password": password}
    headers = {"Content-Type": "application/json"}
    response = requests.post(authEndpoint, json=payload, headers=headers)
    if response.status_code == 200:
        return response.json()['data']['access_token']
    else:
        raise HTTPException(status_code=400, detail="Authentication failed")

# Function to create an item in a Directus collection
def createItemInCollection(token: str, collectionName: str, itemData: dict) -> dict:
    createEndpoint = f"{directusUrl}/items/{collectionName}"
    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}
    response = requests.post(createEndpoint, json=itemData, headers=headers)
    if response.status_code in [200, 201]:
        return response.json()['data']
    else:
        raise HTTPException(status_code=400, detail="Failed to create item")

# Pydantic models for structured request and response bodies
class HealthRecordContent(BaseModel):
    pass

class AllergyContent(HealthRecordContent):
    allergyCode: str
    allergyDescription: str
    reactionCode: str
    severity: str

class MedicationContent(HealthRecordContent):
    medicationCode: str
    medicationName: str
    dosageInstruction: str

class DiagnosisContent(HealthRecordContent):
    diagnosisCode: str
    diagnosisDescription: str

class VerifiableCredential(BaseModel):
    id: str
    type: str
    issueDate: str
    content: Union[AllergyContent, MedicationContent, DiagnosisContent]

class MedicationRecord(BaseModel):
    type: str
    dateFrom: str
    dateTo: str
    presentUrl: str


# Cyclic data for demonstration
recordTypes = ["Medication", "Diagnosis", "AllergyIntolerance"]

demoDates = [
    (datetime(2021, 1, 1), datetime(2022, 12, 31)),
    (datetime(2022, 1, 1), None),  # dateTo is None for demonstration purposes
    (datetime(2023, 1, 1), datetime(2024, 12, 31)),
    (None, None),  # Both dates are None
]

# Converting datetime objects to ISO format and handling None values
isoDates = [
    (start.isoformat() + "Z" if start else None, end.isoformat() + "Z" if end else None) for start, end in demoDates
]

currentTypeIndex = -1
currentDateIndex = -1

class DynamicRecord(BaseModel):
    type: str
    dateFrom: Optional[datetime] = None
    dateTo: Optional[datetime] = None
    presentUrl: str

class Record(BaseModel):
    type: str
    dateFrom: datetime = Field(default_factory=datetime.now)
    dateTo: Optional[datetime] = Field(default_factory=datetime.now)
    presentUrl: str


# Route to handle presentation of Verifiable Credentials
@app.post("/present")
def presentation(vcs: List[VerifiableCredential]):
    token = authenticateDirectus()
    print(vcs)
    try:
        jsonOutput = {
            'vc': [{
                'id': vc.id,
                'type': vc.type,
                'issueDate': vc.issueDate,
                'content': vc.content.dict()
            } for vc in vcs]
        }
    except ValidationError as e:
        raise HTTPException(status_code=400, detail=str(e))

    createdVc = createItemInCollection(token, "vcs", jsonOutput)
    return {"message": "Verifiable Credentials presented successfully!", "data": createdVc}

@app.get("/doctorRequest")
def getDoctorRequest():
    global currentTypeIndex, currentDateIndex
    currentTypeIndex = (currentTypeIndex + 1) % len(recordTypes)
    currentDateIndex = (currentDateIndex + 1) % len(isoDates)

    recordType = recordTypes[currentTypeIndex]
    dateFrom, dateTo = isoDates[currentDateIndex]

    recordData = {
        "type": recordType,
        "dateFrom": dateFrom if dateFrom else None,
        "dateTo": dateTo if dateTo else None,
        "presentUrl": f"{os.getenv('DIRECTUS_URL', 'https://directustesting.proudcoast-33470e41.switzerlandnorth.azurecontainerapps.io')}/present",
    }

    return recordData

# Utility function for local development and testing
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0")