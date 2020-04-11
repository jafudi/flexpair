apt-get install -y --no-install-recommends firefox

cat << EOF > /usr/lib/firefox/browser/defaults/preferences/sysprefs.js
pref("browser.startup.homepage","jafudi.com");
EOF