FROM python:3.10-slim
WORKDIR /app

COPY ./requirements.txt /code/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

CMD ["tail", "-f", "/dev/null"]
