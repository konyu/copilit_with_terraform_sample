# ====================
# DB Subnet Group
# ====================
resource "aws_db_subnet_group" "dsg" {
  tags = {
    Name = "${var.env}-${var.project}-db-subnet-group"
  }
  # サブネットグループに入れるサブネットのIDをlistで指定 ex.["subnet-xxxxxx","subnet-yyyyy"]
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_c.id]
}


# ====================
# RDB
# ====================
# Aurora Serverless
resource "aws_rds_cluster" "rdb" {
  cluster_identifier = "${var.env}-${var.project}-aurora-cluster"
  engine_mode        = "serverless"
  //デフォルトはaurora(mysql5.6)のため、mysql5.7の場合は必ずengine="aurora-mysql"の指定が必要
  engine               = "aurora-mysql"
  engine_version       = "5.7"
  database_name        = "mydb"
  master_username      = var.rds_master_username
  master_password      = var.rds_master_password
  db_subnet_group_name = aws_db_subnet_group.dsg.name
  // 削除時にスナップショットを作成しない
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  scaling_configuration {
    //接続がない場合に、一時停止する
    auto_pause = true
    //一時停止するまでの時間(秒)
    seconds_until_auto_pause = 300
    //スケール可能なキャパシティーユニットの最大値
    max_capacity = 16
    //キャパシティーユニットの最小値
    min_capacity = 1
    //タイムアウト時に強制的にスケーリング
    timeout_action = "ForceApplyCapacityChange"
  }
}