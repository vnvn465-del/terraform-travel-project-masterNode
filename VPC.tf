# ==========================================
# 1. VPC 설정
# ==========================================
resource "aws_vpc" "k8s_vpc" {
  cidr_block           = "172.31.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = { Name = "k8s-main-vpc" }
}

# ==========================================
# 2. 서브넷 설정
# ==========================================
resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.k8s_vpc.id
  cidr_block        = "172.31.0.0/20"
  availability_zone = "ap-northeast-2a"
  tags = { Name = "k8s-subnet-2a" }
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.k8s_vpc.id
  cidr_block        = "172.31.16.0/20"
  availability_zone = "ap-northeast-2b"
  tags = { Name = "k8s-subnet-2b" }
}

resource "aws_subnet" "subnet_3" {
  vpc_id            = aws_vpc.k8s_vpc.id
  cidr_block        = "172.31.32.0/20"
  availability_zone = "ap-northeast-2c"
  tags = { Name = "k8s-subnet-2c" }
}

resource "aws_subnet" "subnet_4" {
  vpc_id            = aws_vpc.k8s_vpc.id
  cidr_block        = "172.31.48.0/20"
  availability_zone = "ap-northeast-2d"
  tags = { Name = "k8s-subnet-2d" }
}

# ==========================================
# 3. 인터넷 게이트웨이(IGW) 생성
# ==========================================
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.k8s_vpc.id
  tags   = { Name = "k8s-igw" }
}

# ==========================================
# 4. 퍼블릭 라우팅 테이블 & 연결 
# ==========================================
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.k8s_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "k8s-public-rt" }
}

# Subnet 1, 2를 퍼블릭으로 연결
resource "aws_route_table_association" "public_1_assoc" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "public_2_assoc" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

# ==========================================
# 5. 프라이빗 라우팅 테이블 & 연결 
# ==========================================
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.k8s_vpc.id
  tags = { Name = "k8s-private-rt" }
}

# Subnet 3, 4를 프라이빗으로 연결
resource "aws_route_table_association" "private_3_assoc" {
  subnet_id      = aws_subnet.subnet_3.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "private_4_assoc" {
  subnet_id      = aws_subnet.subnet_4.id
  route_table_id = aws_route_table.private_rt.id
}
