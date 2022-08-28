import requests
import json
import getpass

url = 'http://localhost:3000/'
headers = {'Content-Type': 'application/json'}

def login():
    username = input("Username: ")
    password = getpass.getpass("Password: ")
    payload = {"username": username, "password": password}
    x = requests.post(url + "auth", data=json.dumps(payload), headers=headers)
    if x.status_code == 200:
        return x.json()["token"]
    else:
        print("Login failed")
        print("Err: " + x.text)

userToken = login()







