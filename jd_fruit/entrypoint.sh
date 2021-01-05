#!/bin/sh
JD_SENDNOTIFY=/JD/sendNotify.js
JDCOOKIE=/JD/jdCookie.js
jdFruitShareCodes=/JD/jdFruitShareCodes.js

fill_cookie() {
	a=$(sed -n '/let SCKEY =/=' $JD_SENDNOTIFY)
	b=$((a-1))
	sed -i "${a}d" $JD_SENDNOTIFY
	varb="let SCKEY = '$sckey';"
	sed -i "${b}a ${varb}" $JD_SENDNOTIFY

	a=$(sed -n '/if (process.env.JD_COOKIE)/=' $JDCOOKIE)
	b=$((a-1))
	sed -i "1,${b}d" $JDCOOKIE
	varb="let CookieJDs = ['$cookie'];"
	sed -i "1 i${varb}" $JDCOOKIE

	a=$(sed -n '/if (process.env.FRUITSHARECODES)/=' $jdFruitShareCodes)
	b=$((a-1))
	sed -i "1,${b}d" $jdFruitShareCodes
	varb="let FruitShareCodes = [''];"
	sed -i "1 i${varb}" $jdFruitShareCodes
}

cron(){
cat > /JD/cronjob << EOF
$cron /JD/entrypoint.sh run
EOF

/usr/local/bin/supercronic ./cronjob
}

update() {
    wget --no-check-certificate -t 3 -T 10 -q https://raw.githubusercontent.com/lxk0301/jd_scripts/master/jd_fruit.js -O /tmp/jd_fruit.js
    wget --no-check-certificate -t 3 -T 10 -q https://raw.githubusercontent.com/lxk0301/jd_scripts/master/jdCookie.js -O /tmp/jdCookie.js
    wget --no-check-certificate -t 3 -T 10 -q https://raw.githubusercontent.com/lxk0301/jd_scripts/master/sendNotify.js -O /tmp/sendNotify.js
    wget --no-check-certificate -t 3 -T 10 -q https://raw.githubusercontent.com/lxk0301/jd_scripts/master/jdFruitShareCodes.js  -O /tmp/jdFruitShareCodes.js


    if [ $? -eq 0 ]; then
        cp -r /tmp/jd_fruit.js /JD/jd_fruit.js
        rm /tmp/jd_fruit.js
		
	cp -r /tmp/jdCookie.js /JD/jdCookie.js
        rm /tmp/jdCookie.js
		
	cp -r /tmp/sendNotify.js /JD/sendNotify.js
        rm /tmp/sendNotify.js

	cp -r /tmp/jdFruitShareCodes.js /JD/jdFruitShareCodes.js
        rm /tmp/jdFruitShareCodes.js
		
    fi
}

run() {
	update
	fill_cookie
	node /JD/jd_fruit.js | tee /JD/log
	echo "$(date) finished" >> /JD/log
}

case $1 in
update)
    update
    ;;
cron)
    cron
    ;;
run)
    run
    ;;
init)
	cron
    ;;
esac
