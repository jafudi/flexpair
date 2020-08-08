Content-Type: multipart/mixed; boundary="====Part=Boundary================================================="
MIME-Version: 1.0

--====Part=Boundary=================================================
Content-Type: text/cloud-config; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.yaml"

#cloud-config

users:
  - default

# Set the system timezone
timezone: Europe/Berlin

write_files:
- owner: ubuntu:ubuntu
  path: /home/ubuntu/podcasts.xml
  content: |
    <?xml version="1.0" encoding="utf-8"?>
    <opml version="2.0">
        <head>
            <title>gPodder subscriptions</title>
            <dateCreated>Sat, 08 Aug 2020 18:34:46 +0200</dateCreated>
        </head>
        <body>
            <outline title="Deutsch: Chaos Computer Club" text="Das monatliche Radio des Chaos Computer Club Berlin" xmlUrl="http://chaosradio.ccc.de/chaosradio-latest.rss" type="rss"/>
            <outline title="Deutsch: Beste Freundinnen" text="Das ist der ultra ehrliche Männerpodcast. Zwei, die so über Liebe, Sex und Partnerschaft reden, als wären sie nur zu zweit. Bei Max &amp; Jakob geht es um Seelenficker, Traumfrauen, Zusammenziehen, Fremdgehen, den besten Sex, One-Night-Stands und alles drum herum. Ohne ein Blatt vor den Mund zu nehmen, bleiben sie so scheiße, wie sie sind. Ihr findet uns auf Instagram unter @bestefreundinnen_podcast" xmlUrl="http://beste-freundinnen.podigee.io/feed/mp3" type="rss"/>
            <outline title="Deutsch: Das Coronavirus-Update mit Christian Drosten" text="Der Virologe Prof. Christian Drosten hat Sars-CoV-2 so gut erforscht wie kaum ein anderer. Alle Welt fragt jetzt nach seinem Rat - uns gibt er regelmäßig Antwort." xmlUrl="https://www.ndr.de/nachrichten/info/podcast4684.xml" type="rss"/>
            <outline title="English: Global News Podcast" text="The day’s top stories from BBC News. Delivered twice a day on weekdays, daily at weekends" xmlUrl="http://downloads.bbc.co.uk/podcasts/worldservice/globalnews/rss.xml" type="rss"/>
            <outline title="Deutsch: Hielscher oder Haase - Deutschlandfunk Nova" text="Aufwachen mit Diane Hielscher oder Till Haase! Montag bis Freitag wissen, was heute wichtig ist. Von Netz bis Politik, von Pop bis Wissenschaft." xmlUrl="https://www.deutschlandfunknova.de/podcast/hielscher-oder-haase" type="rss"/>
            <outline title="Deutsch: Steingarts Morning Briefing – Der Podcast" text="Der Journalist und Buchautor Gabor Steingart informiert und bewertet das politische und wirtschaftliche Weltgeschehen – mit Scharfsinn und Sprachwitz. Dazu: Interviews und Korrespondentenberichte aus aller Welt." xmlUrl="https://dasmorningbriefing.podigee.io/feed/mp3" type="rss"/>
            <outline title="Deutsch: The Mindful Sessions - Für mehr Achtsamkeit &amp; Soulpower" text="Mein Buch &quot;Leb das Leben, das du leben willst&quot; ist jetzt da: https://linktr.ee/sarah.desai ++++++++ Dieses Buch nimmt dich mit auf eine inspirierende Reise. Eine Reise mit dem Ziel dein Leben frei von Zweifeln und inneren Fesseln selbstbestimmt so zu gestalten, wie du es leben willst. Eine Reise zu dir selbst - von deiner Vergangenheit über die gegenwärtige Situation bis hin zu deinen zukünftigen Zielen. Schritt für Schritt wirst du dich mit deinem inneren Kind aussöhnen, deine aktuellen Gedanken und Emotionen positiv beeinflussen und deine Zukunft so gestalten wie du sie dir wünscht. +++ Willkommen bei den The Mindful Sessions - Deinem Podcast für mehr Achtsamkeit und Soulpower. Es erwarten dich konkrete Coaching-Tipps, heilende Meditationen und Experteninterviews, die dir helfen dich in einem neuen Licht zu sehen und dein ganzes Potenzial zu entfalten. Weitere Informationen zu den The Mindful Sessions, Workshops und Vorträgen findest du unter www.sarahdesai.de. Oder schreib gerne eine Mail an: hello@sarahdesai.de. Music: Primavera by Claudio Donzelli Download “Frammenti”: http://bit.ly/FRAMMENTI" xmlUrl="https://themindfulsessions.podigee.io/feed/mp3" type="rss"/>
            <outline title="Deutsch: Wirtschaft in Zeiten von Corona - alles ist anders" text="Das Corona-Virus bringt unseren Alltag durcheinander - alles ist jetzt anders. Das hat auch Folgen für die Wirtschaft - welche, erklärt die NDR Info Wirtschaftsredaktion" xmlUrl="https://www.ndr.de/nachrichten/info/podcast4696.xml" type="rss"/>
            <outline title="Deutsch: Nachrichten - Deutschlandfunk" text="Bestens informiert mit den wichtigsten Nachrichten aus Deutschland und der Welt. Rund um die Uhr aus der Deutschlandfunk-Nachrichtenredaktion." xmlUrl="http://www.dradio.de/rss/podcast/nachrichten/" type="rss"/>
            <outline title="Deutsch: RNZ Corona-Podcast" text="Tracks published by user-289295283 on Soundcloud." xmlUrl="https://soundcloud.com/user-289295283" type="rss"/>
            <outline title="English: WIRED UK Podcast" text="The award-winning WIRED UK Podcast with James Temperton and the rest of the team. Listen every week for the an informed and entertaining rundown of latest technology, science, business and culture news. New episodes every Friday." xmlUrl="https://www.wired.co.uk/rss/podcast" type="rss"/>
            <outline title="English: Exponent" text="A podcast about tech and society, hosted by Ben Thompson and James Allworth" xmlUrl="http://exponent.fm/feed/" type="rss"/>
            <outline title="Deutsch: heute journal" text="" xmlUrl="http://www.zdf.de/rss/podcast/audio/zdf/nachrichten/heute-journal" type="rss"/>
            <outline title="Deutsch: Neugier genügt - das Feature" text="Die Wundertüte von WDR 5" xmlUrl="https://audiothek.ardmediathek.de/programsets/55477882/synd_rss?offset=0&amp;limit=12" type="rss"/>
            <outline title="Deutsch: Eine Stunde Liebe" text="Wir alle wissen viel über Liebe, Sex und Beziehungen. Aber wir wollen noch mehr wissen. Immer freitags im Podcast zur Sendung Eine Stunde Liebe." xmlUrl="https://audiothek.ardmediathek.de/programsets/42835390/synd_rss?offset=0&amp;limit=12" type="rss"/>
            <outline title="Deutsch: Ab 21" text="Ab 21 ist die Abendsendung aus Berlin. Willkommen im Nova-Club, mit interessanten Gästen und ihren Geschichten. Neue Folgen täglich montags bis freitags." xmlUrl="https://audiothek.ardmediathek.de/programsets/50763770/synd_rss?offset=0&amp;limit=12" type="rss"/>
            <outline title="Deutsch: SWR1 Arbeitsplatz" text="Wirtschaft leicht gemacht - Informationen und Emotionen aus der Arbeitswelt. Das Radiomagazin für Arbeitnehmer und Arbeitgeber, für Betroffene und Beobachter, für Eltern und Lehrer, Auszubildende und Ausbilder, Arbeitslose und Überarbeitete. Reportagen aus Betrieben, Hintergründe, Meinungen, Urteile und Interviews." xmlUrl="https://audiothek.ardmediathek.de/programsets/8758200/synd_rss?offset=0&amp;limit=12" type="rss"/>
            <outline title="English: Your Anxiety Toolkit" text="Your Anxiety Toolkit aims to provide you with helpful tools to manage anxiety, stress and other emotions that get in the way." xmlUrl="https://kimberleyquinlan.libsyn.com/rss" type="rss"/>
            <outline title="English: Harvard Business Review IdeaCast" text="A weekly podcast featuring the leading thinkers in business and management." xmlUrl="http://feeds.harvardbusiness.org/harvardbusiness/ideacast" type="rss"/>
            <outline title="English: SuperDataScience" text="Kirill Eremenko is a Data Science coach and lifestyle entrepreneur. The goal of the Super Data Science podcast is to bring you the most inspiring Data Scientists and Analysts from around the World to help you build your successful career in Data Science. Data is growing exponentially and so are salaries of those who work in analytics. This podcast can help you learn how to skyrocket your analytics career. Big Data, visualization, predictive modeling, forecasting, analysis, business processes, statistics, R, Python, SQL programming, tableau, machine learning, hadoop, databases, data science MBAs, and all the analytcis tools and skills that will help you better understand how to crush it in Data Science." xmlUrl="https://feeds.soundcloud.com/users/soundcloud%3Ausers%3A253585900/sounds.rss" type="rss"/>
        </body>
    </opml>

--====Part=Boundary=================================================
Content-Type: text/x-shellscript; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="guacamole-user-script.sh"

#!/usr/bin/env bash

# Check whether required packages are installed to proceed #########

packages=("docker.io")

for pkg in ${packages[@]}; do
    is_pkg_installed=$(dpkg-query -W --showformat='${Status}\n' ${pkg} | grep "install ok installed")

    if [ "${is_pkg_installed}" == "install ok installed" ]; then
        echo ${pkg} is installed.
    else
        echo Missing package ${pkg}! Skip further execution.
        exit 0
    fi
done

# Is there an alternative to removing the user password ? ###########

sudo passwd -d ubuntu # for direct SSH access from guacd_container
chown ubuntu -R /home/ubuntu # handing over home folder to user

# Provision Guacamole stack ########################################

domain=${SSL_DOMAIN}
export GUACAMOLE_HOME=/var/tmp/guacamole
cd ${GUACAMOLE_HOME}

echo "Preparing folder init and creating ./init/initdb.sql"
mkdir ./init >/dev/null 2>&1
mkdir -p ./nginx/ssl >/dev/null 2>&1
rm -rf ./data
docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --postgres > ./init/initdb.sql
sudo chmod -R +x ./init
echo "done"

rsa_key_size=4096
data_path="./letsencrypt/certbot"
mkdir -p ${data_path}
email="socialnets@jafudi.com" # Adding a valid address is strongly recommended
staging=0 # Set to 1 if you're testing your setup to avoid hitting request limits

if [ ! -e "$data_path/conf/options-ssl-nginx.conf" ] || [ ! -e "$data_path/conf/ssl-dhparams.pem" ]; then
  echo "### Downloading recommended TLS parameters ..."
  mkdir -p "$data_path/conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf | sudo tee "$data_path/conf/options-ssl-nginx.conf" > /dev/null
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem | sudo tee "$data_path/conf/ssl-dhparams.pem" > /dev/null
  echo
fi

echo "### Creating dummy certificate for $domain ..."
container_path="/etc/letsencrypt"
host_path="$data_path/conf"
sudo mkdir -p "${host_path}/live"
sudo chmod 777 "${host_path}/live"
docker-compose run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey 'rsa:${rsa_key_size}' -days 90\
    -keyout '${container_path}/live/privkey.pem' \
    -out '${container_path}/live/fullchain.pem' \
    -subj '/CN=localhost'" certbot

echo "### Starting nginx ..."
docker-compose up --force-recreate -d nginx
echo

echo "### Saving away dummy certificate for $domain ..."
sudo mkdir -p ${host_path}/archive/dummy
sudo mv "${host_path}/live/*" "${host_path}/archive/dummy/"
sudo rm -Rf ${host_path}/renewal/$domain.conf

echo "### Requesting Let's Encrypt certificate for $domain ..."
# https://letsencrypt.org/docs/rate-limits/
# 50 certificates per registered domain per week i.e. theworkpc.com
# including other people's certificates!
# + 5 renewals per subdomain per week

# Select appropriate email arg
case "$email" in
  "") email_arg="--register-unsafely-without-email" ;;
  *) email_arg="--email $email" ;;
esac

# Enable staging mode if needed
if [ $staging != "0" ]; then staging_arg="--staging"; fi

mkdir -p "$data_path/logs"

docker-compose run --rm --entrypoint "\
  certbot certonly --webroot --webroot-path /var/www/certbot \
    $staging_arg \
    $email_arg \
    -d $domain \
    --rsa-key-size $rsa_key_size \
    --agree-tos \
    --non-interactive \
    --force-renewal" \
    certbot

exitcode=$?

if [ $exitcode -eq 0 ]; then
  if [ -d "${host_path}/live/$domain-0001" ]; then
    echo "Deduplicating certificate. Look here https://community.letsencrypt.org/t/certbot-renew-request-saves-certificates-to-0001-to-folder/49654/9"
    mv "${host_path}/live/$domain-0001" "${host_path}/live/$domain"
  fi
  sudo cp -L ${host_path}/live/$domain/* ${host_path}/live/

  echo "### Loading nginx and murmur with new certificate..."
  sudo rm -rf ${GUACAMOLE_HOME}/murmur_cert
  sudo mkdir -p ${GUACAMOLE_HOME}/murmur_cert
  sudo cp -L ${host_path}/live/$domain/* ${GUACAMOLE_HOME}/murmur_cert/
  docker-compose up --force-recreate -d nginx
else
  echo "Certbot returned error code '$exitcode'."
  exit 1
fi

--====Part=Boundary=================================================--
