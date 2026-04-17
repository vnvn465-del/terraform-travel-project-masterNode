# 1. S3 버킷 생성: Loki의 로그 데이터와 인덱스를 영구 보관합니다.
resource "aws_s3_bucket" "loki_storage" {
  # 고유한 버킷 명칭 반영
  bucket = "my-loki-log-storage-12"

  tags = {
    Name        = "Loki-Log-Storage"
    Project     = "Travel-K8s"
    Purpose     = "Log-Retention" # 운영 관점의 태그 추가
  }
}

# 2. 버킷 버전 관리: 실수로 로그가 삭제되는 것을 방지하기 위한 안전장치입니다.
resource "aws_s3_bucket_versioning" "loki_versioning" {
  bucket = aws_s3_bucket.loki_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 3. 퍼블릭 액세스 차단: 로그 데이터 유출을 막기 위해 외부 접근을 완전히 차단합니다.
resource "aws_s3_bucket_public_access_block" "loki_storage_block" {
  bucket = aws_s3_bucket.loki_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
