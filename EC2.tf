# EC2 인스턴스 설정: K3s 마스터 노드 역할을 수행하는 서버를 정의합니다.
resource "aws_instance" "k8s_master" {
  ami           = "ami-03fd85ef2fae79c05" 
  
  # K8s 구동을 위한 2vCPU, 8GB RAM 사양 선택
  instance_type = "t3.large"

  # [수정 포인트] 외부 인터넷 연결을 위해 퍼블릭 서브넷(subnet_1, 2a 가용영역)에 배치합니다.
  subnet_id     = aws_subnet.subnet_1.id 
  
  # 앞서 만든 보안 그룹 연결
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]

  # 접속을 위한 기존 키 페어 사용
  key_name      = "travel-key"

  # EFS 마운트 및 S3 접근을 위한 IAM 역할 부여
  iam_instance_profile = "My-K8s-Storage-Role"
  
  # 퍼블릭 IP 자동 할당 (SSH 접속 및 통신을 위해 필수)
  associate_public_ip_address = true

  # 인스턴스 생성 시 K3s를 자동으로 설치하고 초기화하는 스크립트입니다.
  user_data = <<-EOF
              #!/bin/bash
              # K3s 설치 스크립트 실행 (Nginx Ingress 사용을 위해 기본 traefik 제외)
              curl -sfL https://get.k3s.io | sh -s - server \
                --write-kubeconfig-mode 644 \
                --disable traefik
              EOF

  tags = {
    Name = "My-Travel-Server" # 인스턴스 이름 반영
  }
}

# (만약 워커 노드 코드도 있다면 아래처럼 subnet_2 에 배치해 주세요!)
# resource "aws_instance" "k8s_worker" {
#   ...
#   subnet_id = aws_subnet.subnet_2.id  # 워커 노드는 퍼블릭 서브넷(2b)에 분산 배치
#   associate_public_ip_address = true
#   ...
# }
