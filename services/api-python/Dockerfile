FROM python:3.11-alpine
WORKDIR /app
COPY app.py .
RUN pip install --no-cache-dir flask
ENV PORT=5000
EXPOSE 5000
CMD ["python", "app.py"]
