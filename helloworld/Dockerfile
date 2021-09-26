FROM python:3.7

COPY /app /app
COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

EXPOSE 5000
CMD ["python", "/app/server.py"]
