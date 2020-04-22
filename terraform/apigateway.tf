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
  depends_on = [
    aws_api_gateway_integration.options-foo,
    aws_api_gateway_integration.get-foo
  ]
}

resource "aws_api_gateway_resource" "foo" {
  rest_api_id = aws_api_gateway_rest_api.test.id
  parent_id   = aws_api_gateway_rest_api.test.root_resource_id
  path_part   = "foo"
}

resource "aws_api_gateway_method" "options-foo" {
  rest_api_id   = aws_api_gateway_rest_api.test.id
  resource_id   = aws_api_gateway_resource.foo.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options-foo" {
  rest_api_id = aws_api_gateway_rest_api.test.id
  resource_id = aws_api_gateway_resource.foo.id
  http_method = aws_api_gateway_method.options-foo.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_method" "get-foo" {
  rest_api_id   = aws_api_gateway_rest_api.test.id
  resource_id   = aws_api_gateway_resource.foo.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "get-foo" {
  rest_api_id = aws_api_gateway_rest_api.test.id
  resource_id = aws_api_gateway_resource.foo.id
  http_method = aws_api_gateway_method.get-foo.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration" "options-foo" {
  rest_api_id = aws_api_gateway_rest_api.test.id
  resource_id = aws_api_gateway_resource.foo.id
  http_method = aws_api_gateway_method.options-foo.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "options-foo" {
  rest_api_id = aws_api_gateway_rest_api.test.id
  resource_id = aws_api_gateway_resource.foo.id
  http_method = aws_api_gateway_method.options-foo.http_method
  status_code = aws_api_gateway_method_response.options-foo.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin"  = "'example.com'"
  }
}

resource "aws_api_gateway_integration" "get-foo" {
  content_handling        = "CONVERT_TO_TEXT"
  rest_api_id             = aws_api_gateway_rest_api.test.id
  resource_id             = aws_api_gateway_resource.foo.id
  http_method             = aws_api_gateway_method.get-foo.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = replace(aws_lambda_function.foofunc.invoke_arn, "//invocations$/", ":$${stageVariables.alias}/invocations")
}
