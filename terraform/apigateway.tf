resource "aws_api_gateway_rest_api" "test" {
  name = "test"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "test-dev" {
  rest_api_id = aws_api_gateway_rest_api.test.id
  stage_name  = "dev"
  variables = {
    "alias"      = "dev"
    "check_hash" = md5(file("terraform/apigateway.tf"))
  }
}
