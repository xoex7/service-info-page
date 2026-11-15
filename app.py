"""Internal service information page for a fictional department.

All data shown here is synthetic (fictional service, fictional contact).
"""
from flask import Flask, jsonify, render_template_string

VERSION = "1.0.0"

SERVICE_INFO = {
    "name": "Campus Print Service",
    "support_contact": "print-support@example.com",
    "service_hours": "Sunday to Thursday, 08:00 - 16:00",
}

PAGE = """<!DOCTYPE html>
<html lang="en">
<head><meta charset="utf-8"><title>{{ info.name }}</title></head>
<body>
  <h1>{{ info.name }}</h1>
  <p><strong>Support contact:</strong> {{ info.support_contact }}</p>
  <p><strong>Service hours:</strong> {{ info.service_hours }}</p>
  <p><strong>Version:</strong> {{ version }}</p>
</body>
</html>
"""

app = Flask(__name__)


@app.route("/")
def index():
    return render_template_string(PAGE, info=SERVICE_INFO, version=VERSION)


@app.route("/health")
def health():
    return jsonify(status="ok", version=VERSION), 200


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=8080)
