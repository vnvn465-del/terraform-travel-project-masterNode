# 보안 그룹 설정: 클러스터 내부 및 외부와의 통신 규칙을 정의합니다.
resource "aws_security_group" "k8s_sg" {
  name        = "k8s-launch-wizard-1"
  description = "Security group for K3s Cluster and Services"
  vpc_id      = aws_vpc.k8s_vpc.id

  # 1. K3s API Server 통신 (6443)
  # kubectl 명령어나 ArgoCD가 마스터 노드와 통신하기 위해 필수적인 포트입니다.
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "k8s-api"
  }

  # 2. 애플리케이션 서비스 포트 (NodePort: 31689)
  # 배포된 travel-app 서비스에 외부 사용자가 접속하기 위한 포트입니다.
  ingress {
    from_port   = 31689
    to_port     = 31689
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "travel-app"
  }

  # 3. Grafana 대시보드 (NodePort: 32000)
  # 모니터링 지표를 시각화하여 확인하기 위한 관리용 포트입니다.
  ingress {
    from_port   = 32000
    to_port     = 32000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "grafana-nodeport"
  }

  # 4. NFS 공유 스토리지 (2049)
  # EFS 마운트를 통해 파드 간 데이터를 공유하기 위해 필요한 포트입니다.
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "NFS-for-EFS"
  }

  # 5. SSH 관리 접속 (22)
  # 터미널 접속을 위해 보안상 의협님의 특정 IP(14.33.xx.xx)만 허용한 디테일이 훌륭합니다.
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["14.33.36.190/32"] 
    description = "myIP-SSH"
  }

  # 6. HTTP/HTTPS 서비스 포트 (80/443)
  # 기본적인 웹 서비스 통신을 위해 열어둔 포트입니다.
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 아웃바운드 규칙: 노드에서 외부(인터넷)로 나가는 모든 트래픽을 허용합니다.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k8s-cluster-sg"
  }
}
