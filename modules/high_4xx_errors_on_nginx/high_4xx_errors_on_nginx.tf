resource "shoreline_notebook" "high_4xx_errors_on_nginx" {
  name       = "high_4xx_errors_on_nginx"
  data       = file("${path.module}/data/high_4xx_errors_on_nginx.json")
  depends_on = [shoreline_action.invoke_nginx_check_conf_exists,shoreline_action.invoke_nginx_restart]
}

resource "shoreline_file" "nginx_check_conf_exists" {
  name             = "nginx_check_conf_exists"
  input_file       = "${path.module}/data/nginx_check_conf_exists.sh"
  md5              = filemd5("${path.module}/data/nginx_check_conf_exists.sh")
  description      = "Check if the configuration file exists"
  destination_path = "/agent/scripts/nginx_check_conf_exists.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "nginx_restart" {
  name             = "nginx_restart"
  input_file       = "${path.module}/data/nginx_restart.sh"
  md5              = filemd5("${path.module}/data/nginx_restart.sh")
  description      = "Restart NGINX if the configuration file is valid"
  destination_path = "/agent/scripts/nginx_restart.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_nginx_check_conf_exists" {
  name        = "invoke_nginx_check_conf_exists"
  description = "Check if the configuration file exists"
  command     = "`chmod +x /agent/scripts/nginx_check_conf_exists.sh && /agent/scripts/nginx_check_conf_exists.sh`"
  params      = []
  file_deps   = ["nginx_check_conf_exists"]
  enabled     = true
  depends_on  = [shoreline_file.nginx_check_conf_exists]
}

resource "shoreline_action" "invoke_nginx_restart" {
  name        = "invoke_nginx_restart"
  description = "Restart NGINX if the configuration file is valid"
  command     = "`chmod +x /agent/scripts/nginx_restart.sh && /agent/scripts/nginx_restart.sh`"
  params      = []
  file_deps   = ["nginx_restart"]
  enabled     = true
  depends_on  = [shoreline_file.nginx_restart]
}

