#!/bin/bash
yum install -y python3
pip3 install flask

cat <<EOF > /home/ec2-user/app.py
from flask import Flask
app = Flask(__name__)

@app.route("/")
def home():
    return "Hello from App"

app.run(host="0.0.0.0", port=8000)
EOF

python3 /home/ec2-user/app.py &