1. apt 업데이트 
	- Cloud 사용 시 가장 처음에 넣기
2. 자주쓰는 Ubuntu 툴 Install (Network, filesystem 부분)
	- net-tools : IP조회, 포트 통신 여부 등 유용하다! (ifconfig, netstat)
	- tree : 폴더/파일 구조 보고싶을 때 
	- iperf3 : 서버 통신 속도 측정
3. Python Install 
	- pip, venv, kernel, jupyter 설치
4. Anaconda, Ipykernel
	- 위 버전은 24.06 버전.
	- 콘다 설치 ~ 환경 변수 등록 및 bash_script 등록 ~ 주피터 배포
5. Docker + Compose
	- Docker랑 Docker compose 설치.
	- 왜인지... 일반 user docker group add 가 잘 되질 않아서... 아직은 재시작으로 하자. (AWS Linux는 dockerD 재시작 하면 되던데...)
6. Mattermost(Opensource) 설치.
	- 초기 세팅 부분 자동화
7. (미완) AWS user-data
	- 이것저것 실험중

