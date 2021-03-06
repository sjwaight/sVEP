resource "aws_sns_topic" "queryVCFExtended" {
  name = "queryVCFExtended"
}

resource "aws_sns_topic_subscription" "queryVCFExtended" {
  topic_arn = "${aws_sns_topic.queryVCFExtended.arn}"
  protocol = "lambda"
  endpoint = "${module.lambda-queryVCFExtended.function_arn}"
}
resource "aws_sns_topic" "queryGTF" {
  name = "queryGTF"
}

resource "aws_sns_topic_subscription" "queryGTF" {
  topic_arn = "${aws_sns_topic.queryGTF.arn}"
  protocol = "lambda"
  endpoint = "${module.lambda-queryGTF.function_arn}"
}

resource "aws_sns_topic" "pluginConsequence" {
  name = "pluginConsequence"
}

resource "aws_sns_topic_subscription" "pluginConsequence" {
  topic_arn = "${aws_sns_topic.pluginConsequence.arn}"
  protocol = "lambda"
  endpoint = "${module.lambda-pluginConsequence.function_arn}"
}

resource "aws_sns_topic" "pluginUpdownstream" {
  name = "pluginUpdownstream"
}

resource "aws_sns_topic_subscription" "pluginUpdownstream" {
  topic_arn = "${aws_sns_topic.pluginUpdownstream.arn}"
  protocol = "lambda"
  endpoint = "${module.lambda-pluginUpdownstream.function_arn}"
}

resource "aws_sns_topic" "concat" {
  name = "concat"
}

resource "aws_sns_topic_subscription" "concat" {
  topic_arn = "${aws_sns_topic.concat.arn}"
  protocol = "lambda"
  endpoint = "${module.lambda-concat.function_arn}"
}
