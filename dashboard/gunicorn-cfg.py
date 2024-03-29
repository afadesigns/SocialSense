# -*- encoding: utf-8 -*-
"""
Copyright (c) 2019 - present AppSeed.us
"""

bind = '0.0.0.0:5005'
workers = 3  # Increase the number of workers for better performance
worker_class = 'gevent'  # Use gevent worker class for better concurrency and performance
worker_connections = 1000  # Increase worker connections to handle more simultaneous requests
accesslog = '-'
loglevel = 'debug'
capture_output = True
enable_stdio_inheritance = True

# Add the following lines for graceful shutdown and handling of SIGTERM signals
graceful_timeout = 30  # Timeout for graceful shutdown in seconds
timeout = 300  # Connection timeout in seconds
limit_request_line = 8190  # Limit the request line length to prevent abuse
limit_request_fields = 100  # Limit the number of request headers to prevent abuse
