docker build . --file Dockerfile --tag "workflow-testing"
docker compose up -d db
docker run \
  -e TEST="True" \
  -e DATABASE_NAME \
  -e DATABASE_ENGINE \
  -e DATABASE_HOST \
  -e DATABASE_PORT \
  -e DATABASE_USER \
  -e DATABASE_PASSWORD \
  -e DJANGO_ALLOWED_HOSTS \
  -e DJANGO_CSRF_TRUSTED_ORIGINS \
  -e DJANGO_SECRET_KEY \
  "workflow-testing"