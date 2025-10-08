#!/usr/bin/env python3
import os
import json
import argparse
from http.server import BaseHTTPRequestHandler, HTTPServer


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path.startswith("/health"):
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(json.dumps({"status": "ok"}).encode())
        else:
            self.send_response(404)
            self.end_headers()

    # keep logs quiet
    def log_message(self, fmt, *args): 
        return


if __name__ == "__main__":
    port = int(os.getenv("HEALTH_PORT", "8080"))
    parser = argparse.ArgumentParser()
    parser.add_argument("--port", type=int, default=port)
    args = parser.parse_args()
    HTTPServer(("0.0.0.0", args.port), Handler).serve_forever()
