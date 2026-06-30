# 1. EFS 파일 시스템 정의
resource "aws_efs_file_system" "travel_efs" {
  creation_token = "travel-app-efs"
  
  # 데이터 보안을 위한 암호화 활성화
  encrypted      = true

  tags = {
    Name = "travel-app-efs"
  }
}

# 2. 마운트 타겟 설정 (프라이빗 서브넷으로 제한)
# EFS 스토리지를 외부 접근이 차단된 프라이빗 서브넷(2c, 2d)에만 배치하여 보안을 강화합니다.

# 가용 영역 2c (Private Subnet 3) 마운트 타겟
resource "aws_efs_mount_target" "mount_2c" {
  file_system_id  = aws_efs_file_system.travel_efs.id
  
  # vpc.tf에서 생성한 subnet_3의 ID를 동적으로 참조
  subnet_id       = aws_subnet.subnet_3.id 
  
  # EFS 접근을 허용하는 보안 그룹 연동 (NFS 포트 허용 필요)
  security_groups = [aws_security_group.k8s_sg.id] 
}

# 가용 영역 2d (Private Subnet 4) 마운트 타겟
resource "aws_efs_mount_target" "mount_2d" {
  file_system_id  = aws_efs_file_system.travel_efs.id
  
  # 하드코딩 대신 vpc.tf에서 생성한 subnet_4의 ID를 동적으로 참조
  subnet_id       = aws_subnet.subnet_4.id 
  
  security_groups = [aws_security_group.k8s_sg.id]
}

