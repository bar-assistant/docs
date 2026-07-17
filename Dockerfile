FROM python:3-alpine

WORKDIR /docs

RUN pip install --no-cache-dir mkdocs-material

EXPOSE 8000

CMD ["mkdocs", "serve", "--dev-addr=0.0.0.0:8000"]