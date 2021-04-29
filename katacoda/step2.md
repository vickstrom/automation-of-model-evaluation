Before telling GitHub, which endpoint we expect the __PUSH event__ to be sent to, we need to start listen on that specific endpoint. To listen, we will make use of the python module [Flask](https://flask.palletsprojects.com/en/1.1.x/). 

`pip3 install flask==1.1.2`{{execute interrupt}}

Then, create a webserver in a file called `server.py`.      

`touch server.py`{{execute}}

This should listen on an arbitrary port, lets say `1337`, and that expects a POST-request on endpoint `/mlops-server`. Open `server.py`{{open}} and add this content: 

<pre class="file" data-filename="server.py" data-target="prepend">
from flask import Flask, request

# initialize server
app = Flask(__name__)

# add route & method
@app.route('/mlops-server', methods=['POST'])
def mlops_server_endpoint():
    request_data = request.get_json()
    return 'Awaiting POST'

# start server 
if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=False, port=1337)
</pre>

By running `python3 server.py`{{execute interrupt}}, you start the webserver. Now the server awaits a POST request at `http://[[HOST_SUBDOMAIN]]-1337-[[KATACODA_HOST]].environments.katacoda.com/mlops-server`. The __POST__ request will contain JSON data in its body, which will contain all the data belonging to a pull request event. This URL will be used when creating our GitHub App.
