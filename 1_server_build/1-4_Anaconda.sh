# conda 설치 (버전 확인하고 잘 골라오기)
wget https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-x86_64.sh

# 무결성 검증(해싱) - 공식사이트에서 잘 가져오면 생략하셈
sha256sum Anaconda3-2024.06-1-Linux-x86_64.sh

# conda 설치 script 실행
bash Anaconda3-2024.06-1-Linux-x86_64.sh
# 일반적으로 자동으로 binary 등록되는데, 안된다면 해당 user의 'bashrc' 파일 찾아서 anaconda bash script 경로 추가해주면 됨
# bash에 환경변수 추가
echo 'export PATH="$HOME/anaconda3/bin:$PATH"' >> ~/.bash_profile
# bash에 변경사항 적용
source ~/.bashrc

# conda base 환경 실행
conda activate base

# jupyter, ipykernel 설치
pip install jupyter
pip install ipykernel

# Jupyter 외부 호스팅 허용 (all allow)
echo "c.ServerApp.ip = '0.0.0.0'" >> ~/.jupyter/jupyter_notebook_config.py

# 경로 이동. 경로가 다를 시 conda env list 인가? 하면 나올거에요
cd /home/ubuntu/anaconda3/

# jupyter notebook 실행 후 링크 복사 (서버에서 자동으로 서치해옴.)
jupyter notebook
