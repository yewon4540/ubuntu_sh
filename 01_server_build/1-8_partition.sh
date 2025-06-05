# 신규 마운트
sudo mkdir -p /home/mountdir
sudo mount /dev/sda1 /home/mountdir
/dev/sda3 /mnt/mydrive ext4 defaults 0 2

# 기존 LVM 마운트
sudo vgs
sudo lvcreate -L 100G -n new_lv ubuntu-vg
sudo mkfs.ext4 /dev/ubuntu-vg/new_lv
sudo mkdir -p /home/mountdir
sudo mount /dev/ubuntu-vg/new_lv /home/user/workspace
echo '/dev/ubuntu-vg/new_lv /home/user/workspace ext4 defaults 0 2' | sudo tee -a /etc/fstab

# 기존 Volume 수정
SYSTEM BACKUP
sudo lvdisplay /dev/ubuntu-vg/ubuntu-lv
or sudo vgs(or lvs)
sudo lvextend -L +100G(or 100%FREE) /dev/ubuntu-vg/ubuntu-lv
sudo resize2fs /dev/ubuntu--vg/ubuntu--lv
