count=100
for i in $(seq $count); do
    curl http://angular-dev-alb-916757676.us-east-1.elb.amazonaws.com
done