import os
from json import JSONDecodeError
from locust import HttpUser, SequentialTaskSet, task, between, events
from locust_plugins.appinsights_listener import ApplicationInsights


class UserSequence(SequentialTaskSet):

    @task
    def get_sample(self):
        self.client.get("/api/QuickFunction", name="Sample GET request")

    # @task
    # def post_sample(self):
    #     self.client.post("/api/QuickFunction", json={"type":"loadtest", "summary":"hi there - locust here"}, name="Sample POST request")

class WebsiteUser(HttpUser):
    tasks  = [UserSequence]
    #wait_time = between(0.5, 2.5)

# Init logger to ApplicationInsights
@events.init.add_listener
def on_locust_init(environment, **_kwargs):
    ApplicationInsights(env=environment, instrumentation_key=os.environ["APPINSIGHTS_INSTRUMENTATIONKEY"])
