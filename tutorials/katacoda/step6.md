In section 1, the communication with the repository was rather one-sided; the server could only _listen_ to __Webhook events__. In order to send requests _to_ our repository, we need to add functionality. First of all, we need to fetch an __access token__. The purpose of the __access token__ is authenticate against GitHub. This is done by constructing a __JSON Web Token__ (JWT) based on the __app ID__ and __private key__ from section 2.

Let's generate our __JWT__. The different `time` fields (`iat`, `exp`) represent for how long this should be valid in terms of seconds. For this, we'll use the `PyJWT` module.   

`pip3 install pyjwt==2.1.0`{{execute}} 

Update `cryptography` as well, as `PyJWT` is dependent on it:     

`pip3 install cryptography==3.4.7`{{execute}}    

In `server.py`{{open}}, add this:

<pre class="file" data-filename="server.py" data-target="prepend">
import jwt
import time
</pre>

<pre class="file">
# ...
def generate_jwt():
    pemfile = open(PRIVATE_KEY_PATH, 'r')
    key = pemfile.read()
    pemfile.close()
    payload = {
        "iat": int(time.time() - 60),
        "exp": int(time.time() + (10 * 60)) - 10,
        "iss": APP_ID
    }
    return jwt.encode(payload, key, algorithm="RS256")
# ...
</pre>

Using `generate_jwt()` we create a function for fetching the __access token__, which essentially sends a `POST` request to `https://api.github.com/app` in order to fetch an access token for a certain __GitHub app__. Let's use `requests` to do a `POST` request.

<pre class="file" data-filename="server.py" data-target="prepend">
import requests 
</pre>

<pre class="file">
# ...
GITHUB_APP_URL = "https://api.github.com/app"

def get_token():
    headers = {
        "Authorization": f"Bearer {generate_jwt()}",
        "Accept": "application/vnd.github.v3+json"
    }
    r = requests.post(f"{GITHUB_APP_URL}/installations/{INSTALL_ID}/access_tokens", headers=headers)
    return r.json()["token"]
# ...
</pre>

To later post a message on a certain __pull request__, we use the __access token__ to send a `POST` request with a body containing our message.  

<pre class="file">
# ...
def post_message_on_pull_request(comments_url, token, message):
    headers = {
        "Authorization": f"token {token}",
        "Accept": "application/vnd.github.v3+json"
    }
    payload = {
        "body": message
    }

    requests.post(comments_url, headers=headers, data=json.dumps(payload))
# ...
</pre>