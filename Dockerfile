FROM python:3.12-slim-bullseye

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PATH=/opt/venv/bin:$PATH

RUN apt-get update && apt-get install -y \
    libpq-dev libjpeg-dev libcairo2 gcc \
    && rm -rf /var/lib/apt/lists/*

RUN python -m venv /opt/venv
RUN pip install --upgrade pip

WORKDIR /code

COPY requirements.txt /tmp/requirements.txt
COPY ./src /code

RUN pip install -r /tmp/requirements.txt

CMD ["bash", "-c", "python manage.py migrate --no-input && gunicorn saas.wsgi:application --bind [::]:${PORT:-8000}"]
