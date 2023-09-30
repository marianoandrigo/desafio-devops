resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id     = "my-db-credentials" # Reemplaza con el nombre de tu secreto en AWS Secrets Manager
  secret_string = "{\"username\":\"mariano\", \"password\":\"devops517\"}" # Esto es solo un ejemplo
}