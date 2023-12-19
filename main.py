import functions_framework
import requests

# Triggered by a change in a storage bucket
@functions_framework.cloud_event
def hello_gcs(cloud_event):
    data = cloud_event.data
    name = data["name"]
    deliver_json(name)

def deliver_json(json_path):
    # /download_json/?json_path=user-id-1/test2
    ngrok_io = "https://0510-35-245-103-1.ngrok.io/"

    fastapi_url = f"{ngrok_io}download_json?json_path={json_path}"
    print("fastapi_url: ", fastapi_url)

    # Cloud Function 코드 내에서 이 부분을 적절히 설정하여 요청을 보낼 수 있습니다.
    response = requests.get(fastapi_url)
    return {"message": f"{json_path}"}