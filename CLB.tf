# 로드밸런서 설정: 외부 사용자가 서비스에 접속할 수 있는 단일 진입점을 정의합니다.
resource "aws_elb" "travel_lb" {
  name               = "travel-app-lb"
  
  # 1. 네트워크 배치: 외부 트래픽을 받기 위해 '퍼블릭 서브넷(1번, 2번)'에만 배치합니다.
  subnets            = [
    aws_subnet.subnet_1.id, 
    aws_subnet.subnet_2.id
  ]

  # 2. 보안 그룹: 외부 HTTP 요청을 허용하는 보안 그룹 연결
  security_groups    = [aws_security_group.k8s_sg.id]

  # 3. 리스너 설정: 외부의 80포트 요청을 내부 EC2의 K3s NodePort(31728)로 전달합니다.
  listener {
    instance_port     = 31728
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  # 4. 상태 검사(Health Check): EC2(노드)가 살아있는지 주기적으로 확인합니다.
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:31728/"
    interval            = 30
  }

  # 5. 대상 인스턴스 연결 (마스터 노드와 워커 노드 모두 연결)
  # CLB가 들어오는 트래픽을 마스터와 워커 노드로 분산하여 전달합니다.
  instances = [
    aws_instance.k8s_master.id,
    aws_instance.k8s_worker.id
  ]
  
  # 6. 고가용성 옵션: 가용 영역(AZ) 간의 트래픽을 고르게 분산시킵니다.
  cross_zone_load_balancing = true
  idle_timeout              = 400

  tags = {
    Name = "travel-app-lb"
  }
}
