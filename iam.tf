# 1. IAM 역할(Role) 생성: EC2 인스턴스가 사용할 신분증을 만듭니다.
resource "aws_iam_role" "k8s_storage_role" {
  name = "My-K8s-Storage-Role"

  # EC2 서비스가 이 역할을 가질 수 있도록 허용하는 신뢰 정책
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "k8s-storage-role"
  }
}

# 2. S3 전체 권한 연결 
# Loki 로그 저장 및 관리를 위해 S3 서비스에 대한 모든 권한을 부여합니다.
resource "aws_iam_role_policy_attachment" "s3_full_access" {
  role       = aws_iam_role.k8s_storage_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# 3. EFS 전체 권한 연결 
# 쿠버네티스 파드가 EFS 볼륨을 생성하고 마운트할 수 있도록 권한을 부여합니다.
resource "aws_iam_role_policy_attachment" "efs_full_access" {
  role       = aws_iam_role.k8s_storage_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemFullAccess"
}

# 4. 인스턴스 프로파일 생성
# 생성한 Role을 실제 EC2 인스턴스에 '입히기' 위한 매개체입니다.
resource "aws_iam_instance_profile" "k8s_instance_profile" {
  name = "My-K8s-Storage-Role" # 보통 역할 이름과 동일하게 설정하여 관리합니다.
  role = aws_iam_role.k8s_storage_role.name
}
