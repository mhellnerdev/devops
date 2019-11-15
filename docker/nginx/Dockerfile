FROM ubuntu:18.04

RUN mkdir /app

COPY urls.txt /app

RUN apt-get update -y && apt-get upgrade -y 
RUN apt-get install nginx -y

EXPOSE 80
EXPOSE 443
 
CMD cat /app/urls.txt
CMD service nginx start

# allows for nginx to stay running. run docker run -d
CMD ["nginx", "-g", "daemon off;"]