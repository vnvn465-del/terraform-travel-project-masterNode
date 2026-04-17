# 로드밸런서 설정: 외부 사용자가 서비스에 접속할 수 있는 단일 진입점을 정의합니다.
resource "aws_elb" "travel_lb" {
  name               = "travel-app-lb"
  
  # 4개 가용 영역(2a, 2b, 2c, 2d)의 서브넷 모두 연결
  subnets            = [
    "subnet-0a86f29e25d29c861", 
    "subnet-0099b6b0280667a14", 
    "subnet-0bc367e1cedbbfe0d", 
    "subnet-0accbbe235158e573"
  ]

  #  보안 그룹 설정
  security_groups    = [aws_security_group.k8s_sg.id]

  # 리스너 설정 (캡처 확인: HTTP 80 -> Instance 31728)
  listener {
    instance_port     = 31728
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  # 상태 검사(Health Check): 서비스가 정상인지 확인합니다.
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:31728/"
    interval            = 30
  }

  # 대상 인스턴스 연결
  instances           = [aws_instance.k8s_master.id]
  cross_zone_load_balancing = true
  idle_timeout        = 400

  tags = {
    Name = "travel-app-lb"
  }
}
