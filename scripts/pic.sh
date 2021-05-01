DATE=$(date '+%h_%Y_%d_%I_%m_%S.png'); flameshot gui -r > ~/pictures/$DATE; ~/scripts/upload.sh zipline ~/pictures/$DATE
