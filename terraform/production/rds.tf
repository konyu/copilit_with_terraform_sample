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
# RDB クラスタ
# ====================
# Aurora MySQL
resource "aws_rds_cluster" "rdb_cluster" {
  cluster_identifier = "${var.env}-${var.project}-rdb-cluster"
  engine               = "aurora-mysql"
  engine_version       = "5.7.mysql_aurora.2.10.0"
  # availability_zones      = [var.az["az_a"], var.az["az_c"]]
  database_name        = "mydb"
  master_username      = var.rds_master_username
  master_password      = var.rds_master_password

  # インスタンスのサイズのサイズ
  # TODO

  db_subnet_group_name = aws_db_subnet_group.dsg.name

  # セキュリティグループ
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  # 7日間バックアップを保持する
  backup_retention_period = "7"
}

# ====================
# RDB クラスタインスタンス
# ====================
resource "aws_rds_cluster_instance" "rdb_instance" {
  count              = 2
  # インスタンスごとに素になるようにidentifierを設定する必要があるのでcount.indexを利用する
  identifier         = "${var.env}-${var.project}-rdb-instance-${count.index}"
  cluster_identifier = "${aws_rds_cluster.rdb_cluster.id}"
  instance_class     = "db.r3.large"
  # クラスタと同じエンジンとバージョンを指定する
  engine             = "${aws_rds_cluster.rdb_cluster.engine}"
  engine_version     = "${aws_rds_cluster.rdb_cluster.engine_version}"
}