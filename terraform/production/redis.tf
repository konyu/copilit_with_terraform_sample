# ====================
# Redis Subnet Group
# ====================
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name = "${var.env}-${var.project}-redis-subnet-group"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_c.id]
}


# ====================
# Redis
# ====================
resource "aws_elasticache_replication_group" "redis" {
  replication_group_id = "${var.env}-${var.project}-redis-cluster"
  replication_group_description = "${var.env}-${var.project}-redis-cluster"
  node_type                     = "cache.t3.small"
  number_cache_clusters         = var.redis_node_count
  automatic_failover_enabled    = var.redis_node_count == 1 ? false : true
  engine_version                = "6.x"
  security_group_ids = [aws_security_group.redis_private_sg.id]
  subnet_group_name  = aws_elasticache_subnet_group.redis_subnet_group.name
}