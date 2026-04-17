# 1. VPC 설정: 클러스터 전체의 가상 네트워크 망을 정의합니다.
resource "aws_vpc" "k8s_vpc" {
  cidr_block           = "172.31.0.0/16"
  
  # 인스턴스가 도메인 네임(예: ec2-xx.compute.internal)을 가질 수 있도록 활성화합니다.
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    # 관리의 편의성을 위해 이름을 지정합니다.
    Name = "k8s-main-vpc"
  }
}

# 2. 서브넷 설정: VPC 내부를 4개의 가용 영역(AZ)으로 쪼개어 가용성을 확보합니다.
# 각 서브넷은 /20 대역(약 4,000개의 IP)으로 나누어 향후 파드 확장에 대비합니다.

# 가용 영역 2a (서울 리전의 첫 번째 데이터 센터)
resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.k8s_vpc.id
  cidr_block        = "172.31.0.0/20"
  availability_zone = "ap-northeast-2a"
  tags = { Name = "k8s-subnet-2a" }
}

# 가용 영역 2b (서울 리전의 두 번째 데이터 센터)
resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.k8s_vpc.id
  cidr_block        = "172.31.16.0/20"
  availability_zone = "ap-northeast-2b"
  tags = { Name = "k8s-subnet-2b" }
}

# 가용 영역 2c (서울 리전의 세 번째 데이터 센터)
resource "aws_subnet" "subnet_3" {
  vpc_id            = aws_vpc.k8s_vpc.id
  cidr_block        = "172.31.32.0/20"
  availability_zone = "ap-northeast-2c"
  tags = { Name = "k8s-subnet-2c" }
}

# 가용 영역 2d (서울 리전의 네 번째 데이터 센터)
resource "aws_subnet" "subnet_4" {
  vpc_id            = aws_vpc.k8s_vpc.id
  cidr_block        = "172.31.48.0/20"
  availability_zone = "ap-northeast-2d"
  tags = { Name = "k8s-subnet-2d" }
}

# 3. 인터넷 게이트웨이(IGW): VPC 내부의 자원들이 외부 인터넷과 통신할 수 있는 관문 역할을 합니다.
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.k8s_vpc.id
  tags   = { Name = "k8s-igw" }
}
