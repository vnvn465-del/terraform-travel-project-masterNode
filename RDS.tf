# RDS 설정: 애플리케이션 데이터를 저장하는 관계형 데이터베이스를 정의합니다.
resource "aws_db_instance" "k8s_db" {
  allocated_storage    = 20
  #  MySQL 8.0 대역 사용
  engine               = "mysql"
  engine_version       = "8.0"
  #  t3.small 사양 (2vCPU, 2GB RAM)
  instance_class       = "db.t3.small"
  
  db_name              = "travel_db" # 실제 사용하시는 DB 이름으로 변경
  identifier           = "database-1"
  
  # 관리자 정보 (일단 구조만 작성)
  username             = "root"
  password             = "password" # 실제 비밀번호
  
  #  ap-northeast-2a 가용영역에 배치
  availability_zone    = "ap-northeast-2a"
  
  # 보안 그룹 연결 
  vpc_security_group_ids = ["sg-0b7217791bf2d7d36"] #default SG ID

  skip_final_snapshot  = true
  publicly_accessible  = false # 보안을 위해 외부 접근 차단

  tags = {
    Name = "k8s-mysql-db"
  }
}
