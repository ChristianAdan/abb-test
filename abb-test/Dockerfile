FROM python:3.10-slim
ENV DB_USER=counteruser
ENV DB_PASSWORD=password
ENV DB_HOST=postgres
ENV DB_PORT=5432
ENV DB_NAME=visitorcounter
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
ENV FLASK_APP=visitors_counter.py
ENV FLASK_RUN_HOST=0.0.0.0
EXPOSE 5000
CMD ["flask", "run"]
