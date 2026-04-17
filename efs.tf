# 1. EFS 파일 시스템 정의
resource "aws_efs_file_system" "travel_efs" {
  creation_token = "travel-app-efs"
  
  # 암호화 활성화 상태
  encrypted      = true

  tags = {
    Name = "travel-app-efs"
  }
}

# 2. 마운트 타겟 설정 (캡처 확인: 4개 AZ 모두 연결)
# 각 가용 영역의 서브넷에서 EFS에 접근할 수 있도록 통로를 뚫어줍니다.

resource "aws_efs_mount_target" "mount_2a" {
  file_system_id  = aws_efs_file_system.travel_efs.id
  subnet_id       = "subnet-0a86f29e25d29c861" # 2a 서브넷 ID
  security_groups = [aws_security_group.k8s_sg.id]
}

resource "aws_efs_mount_target" "mount_2b" {
  file_system_id  = aws_efs_file_system.travel_efs.id
  subnet_id       = "subnet-0099b6b0280667a14" # 2b 서브넷 ID
  security_groups = [aws_security_group.k8s_sg.id]
}

resource "aws_efs_mount_target" "mount_2c" {
  file_system_id  = aws_efs_file_system.travel_efs.id
  subnet_id       = "subnet-0bc367e1cedbbfe0d" # 2c 서브넷 ID
  security_groups = [aws_security_group.k8s_sg.id]
}

resource "aws_efs_mount_target" "mount_2d" {
  file_system_id  = aws_efs_file_system.travel_efs.id
  subnet_id       = "subnet-0accbbe235158e573" # 2d 서브넷 ID
  security_groups = [aws_security_group.k8s_sg.id]
}
