import time
from locust import HttpUser, task, between

class QuickstartUser(HttpUser):
    wait_time = between(0.5, 2.5)

    @task(1)
    def list_claims(self):
        self.client.get("/api/claim", name="LIST claims")

# This exists only in bic: 4e0ccc22-ee8f-4904-9b4f-ab3b3a4a40f1
# This exists only in TF: 69f698a7-21bf-462d-afa0-86adbb3e40c5

    @task(2)
    def view_claim(self):
        for item_id in ["4e0ccc22-ee8f-4904-9b4f-ab3b3a4a40f1", "69f698a7-21bf-462d-afa0-86adbb3e40c5"]:
            self.client.get(f"/api/claim/{item_id}", name="GET existing claim")

    @task(3)
    def post_claim(self):           
        self.client.post("/api/claim", json={"type":"terraform", "status":"bar", "summary":"hi there - locust here"}, name="POST new claim")