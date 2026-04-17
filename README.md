Travel-app_마스터노드 Terraform 코드화 파일   <br>
- AWS Provider	프로젝트가 배포될 리전(ap-northeast-2) 및 테라폼 버전 정의  <br>
- VPC & Subnets	4개의 가용 영역(AZ)에 걸친 서브넷 설계로 네트워크 단의 고가용성 확보  <br>
- Security Groups	K3s API(6443), 서비스(NodePort), NFS(2049) 등 서비스별 최소 포트 개방 및 관리자 IP 제한  <br>
- IAM Role & Policy	EC2가 S3(로그 저장) 및 EFS(데이터 공유)에 접근하기 위한 인스턴스 프로파일 및 권한 정의  <br>
- Master Node	t3.large 기반의 K3s 컨트롤 플레인. User Data를 사용하여 인스턴스 생성 시 K3s 자동 설치 및 초기화  <br>
- RDS	애플리케이션 데이터 영속성을 위한 MySQL 8.0 구축. 프라이빗 서브넷 배치를 통한 데이터 보안 강화  <br>
- EFS	멀티 노드 파드 간 데이터 공유를 위한 공유 파일 시스템. 4개 AZ 모두에 마운트 타겟 구성  <br>
- S3	Loki 로그 데이터의 장기 보관을 위한 버킷. 버전 관리(Versioning)를 통한 데이터 유실 방지  <br>
- Load Balancer	외부 트래픽을 클러스터로 분산 전달하는 관문. HTTP(80)를 K8s NodePort로 포워딩  <br>
