docker stop  $(docker ps -a -q)
docker rm  	 $(docker ps -a -q)
docker rmi  test
docker build -t test .  
docker run -p 80:80 -p 443:443 -p 3306:3306 -it test