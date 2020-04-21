data "archive_file" "foofunc-zip" {
  type        = "zip"
  source_dir  = "src"
  output_path = "dist/foofunc.zip"
}

resource "aws_lambda_function" "foofunc" {
  filename         = "dist/foofunc.zip"
  source_code_hash = data.archive_file.foofunc-zip.output_base64sha256
  function_name    = "foofunc"
  role             = aws_iam_role.foofunc-executer.arn
  handler          = "index.handler"
  runtime          = "nodejs12.x"
  memory_size      = 128
  timeout          = 10
}

resource "aws_lambda_alias" "foofunc-dev" {
  name             = "dev"
  function_name    = aws_lambda_function.foofunc.function_name
  function_version = "$LATEST"
}

resource "aws_lambda_permission" "allow-get-foo-dev" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.foofunc.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.test.execution_arn}/*/*/*"
  depends_on    = [aws_lambda_alias.foofunc-dev]
  qualifier     = "dev"
}
