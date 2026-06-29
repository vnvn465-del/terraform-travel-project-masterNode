# 1. DB 서브넷 그룹 생성 (프라이빗 서브넷 지정)
# RDS를 외부 접근이 차단된 Private Subnet(2c, 2d)에만 배치되도록 묶어줍니다.
resource "aws_db_subnet_group" "private_db_subnet" {
  name       = "k8s-private-db-subnet-group"
  
  # VPC 코드에서 만든 프라이빗 서브넷의 ID를 참조합니다.
  subnet_ids = [aws_subnet.subnet_3.id, aws_subnet.subnet_4.id]

  tags = {
    Name = "k8s-private-db-subnet-group"
  }
}

# 2. RDS (MySQL) 인스턴스 생성
resource "aws_db_instance" "k8s_db" {
  # 스토리지 설정
  allocated_storage    = 20
  
  # 데이터베이스 엔진 설정
  engine               = "mysql"
  engine_version       = "8.0"
  
  # 인스턴스 사양 설정 (2vCPU, 2GB RAM)
  instance_class       = "db.t3.small"
  
  # DB 설정
  db_name              = "travel_db"
  identifier           = "database-1"
  
  # 관리자 정보 
  username             = "root"
  password             = "password" 
  
  # 네트워크 및 서브넷 배치 (위에서 만든 프라이빗 서브넷 그룹 참조)
  db_subnet_group_name = aws_db_subnet_group.private_db_subnet.name 
  
  # 보안 그룹(SG) 연결 (K3s 노드에서만 접근 가능하도록 설정된 SG ID)
  vpc_security_group_ids = ["sg-0b7217791bf2d7d36"] 

  # 보안: 외부 인터넷에서 다이렉트로 접속 불가능하게 완벽 차단
  publicly_accessible  = false 
  
  # 테스트 및 삭제 편의성을 위해 최종 스냅샷 생성 생략
  skip_final_snapshot  = true

  tags = {
    Name = "k8s-mysql-db"
  }
}
