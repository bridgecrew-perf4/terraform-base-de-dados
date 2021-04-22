provider "aws" {
  version = ">= 3.1.0"
  region  = var.region
}
provider "mysql" {
  endpoint = aws_db_instance.database.endpoint
  username = var.user_username
  password = var.password_username
}
resource "aws_db_instance" "database" {
  allocated_storage    = 20
  storage_type         = "gp2"
  identifier           = "user"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "dsuser"
  username             = var.user_username
  password             = var.password_username
  db_subnet_group_name = "teste"
  parameter_group_name = "default.mysql5.7"
  vpc_security_group_ids = var.sg
  publicly_accessible = true
}
resource "mysql_database" "aplicacao" {
  name = "aplicacao"
}
resource "mysql_database" "logs" {
  name = "logs"
}
resource "mysql_user" "app" {
  user               = "app"
  host               = "%"
  plaintext_password = var.passwd
}
resource "mysql_grant" "app" {
  user       = mysql_user.app.user
  host       = mysql_user.app.host
  database   = "aplicacao"
  privileges = ["SELECT"]
}
resource "mysql_user" "api" {
  user               = "api"
  host               = "%"
  plaintext_password = var.passwd_api
}
resource "mysql_grant" "api" {
  user       = mysql_user.api.user
  host       = mysql_user.api.host
  database   = "aplicacao"
  privileges = ["INSERT"]
}
resource "mysql_user" "convidado" {
  user               = "convidado"
  host               = "%"
  plaintext_password = var.passwd_convidado
}
resource "mysql_grant" "convidado" {
  user       = mysql_user.convidado.user
  host       = mysql_user.convidado.host
  database   = "aplicacao"
  privileges = ["SELECT"]
}
