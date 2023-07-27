FROM python:3.10-slim
WORKDIR /usr/app

WORKDIR /python
COPY ./app/requirements.txt .
RUN pip install -r requirements.txt

CMD ["tail", "-f", "/dev/null"]
