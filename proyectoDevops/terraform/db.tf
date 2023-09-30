resource "aws_db_instance" "my_db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "13.7"
  instance_class       = "db.t3.micro"
  username             = "mariano"
  password             = "devops517"
  parameter_group_name = "default.postgres13"
  skip_final_snapshot  = true
  publicly_accessible  = true
  username             = jsondecode(aws_secretsmanager_secret_version.db_credentials.secret_string)["username"]
  password             = jsondecode(aws_secretsmanager_secret_version.db_credentials.secret_string)["password"]
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name = aws_db_subnet_group.my_db_subnet_group.name
 }