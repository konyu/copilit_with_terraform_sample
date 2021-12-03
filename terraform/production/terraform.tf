provider "aws" {
    region = "ap-northeast-1"
}
# s3にファイルをアップロードしてそこから実行する設定
# これを有効にすると　どのIAMロールかはわからないがそれを使ってCloudformationが動く？
# terraform {
#   backend "s3" {
#     bucket = "【バケット名】"
#     key    = "dev/terraform.tfstate"
#     region = "ap-northeast-1"
#   }
# }

# provider "aws" {
#   region = "ap-northeast-1"
# }