resource "aws_lambda_alias" "foofunc-v1" {
  name             = "v1"
  function_name    = aws_lambda_function.foofunc.function_name
  function_version = "3"
  depends_on       = [aws_lambda_function.foofunc]
}

resource "aws_lambda_permission" "allow-get-foo-v1" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.foofunc.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.test.execution_arn}/*/*/*"
  depends_on    = [aws_lambda_alias.foofunc-v1]
  qualifier     = "v1"
}

resource "aws_api_gateway_deployment" "test-v1" {
  rest_api_id = aws_api_gateway_rest_api.test.id
  stage_name  = "v1"
  variables = {
    "alias"        = "v1"
    "published_at" = "2020-04-22 18:00:00"
  }
  depends_on = [
    aws_lambda_permission.allow-get-foo-v1
  ]
}
