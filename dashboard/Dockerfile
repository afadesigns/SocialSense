FROM python:3.9-slim-buster

# set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# change to the app directory
WORKDIR /app

# copy and install python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    rm requirements.txt

# copy the rest of the application
COPY . .

# run migrations
RUN python manage.py migrate

# expose the port
EXPOSE 8000

# run gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "3", "--threads", "2", "core.wsgi"]
