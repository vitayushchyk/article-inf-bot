import os

DATABASES = {
    "NAME": os.environ.get("POSTGRES_DB"),
    "USER": os.environ.get("POSTGRES_USER"),
    "PASSWORD": os.environ.get("POSTGRES_PASSWORD"),
    "HOST": os.environ.get("DB_HOST"),
    "PORT": os.environ.get("DB_PORT"),
}

SERVER_PORT = os.environ.get("SERVER_PORT")
