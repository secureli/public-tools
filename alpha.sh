
# Ultimate Pentesting Day #1 (Strategic Security Class by Joe McCray)
# Homework Assignment #1

# OSSEC Report Helper (ossec-helper.sh)
# usage:

# ./ossec-helper.sh [domain.com]

# requirements:

# - recon-ng
# - theharvester

# future updates:

# - flask web interface
# - prettier pdf + stitching
# - possibly use phantomjs instead of curl for more advancement

#######################################################################
# engineered by john@secureli.com & co-authored by james@secureli.com #
#######################################################################

rm $1.recon

mkdir "./$1"

echo "keys add bing_api d186b37f4ace45edaaf8209012799889" >> $1.recon
echo "keys add builtwith_api 9a74cc2b-9c1c-4cf2-b32e-a349158ef7d9" >> $1.recon
echo "keys add google_api AIzaSyBR2fflgt0O0fYpKnjNqFubTtCiqmdPrJs" >> $1.recon
echo "keys add google_cset AIzaSyBR2fflgt0O0fYpKnjNqFubTtCiqmdPrJs" >> $1.recon
echo "keys add linkedin_api 78mjjd88ztvcfl" >> $1.recon
echo "keys add linkedin_secret ounO7pER7Q0ZXXCj" >> $1.recon
echo "keys add shodan_api ULAqZuKzub6waFpbmlpvrLdek5QDsXYB" >> $1.recon
# grab wikipedia & parse | find subsidiaries (vhosts, self hosted, etc.) very important for social engineering (SET)


#recon-ng script
./recon-ng/recon-ng -r $1.recon

# fierce
python3 fierce/fierce.py --domain facebook.com --subdomains admin --traverse 10 > "./$1/fierce.txt"

# gxfr
python gxfr.py --both -o

# metagoofil

python metagoofil/metagoofil.py -d $1 -t doc,pdf -l 100 -n 3 -o "./$1/metadata"

# harvester

python theHarvester/theHarvester.py -d $1 -l 200 -b all > "./$1/harvest.txt"

# grab p0f

# banner grab via nmap with full scan

# robtex
curl "https://www.robtex.com/?dns=$1" > "./$1/robtex.html"
xvfb-run wkhtmltopdf ./$1/robtex.html ./$1/robtex.pdf

# netcraft
curl "http://toolbar.netcraft.com/site_report?url=$1" > "./$1/netcraft.html"
 xvfb-run wkhtmltopdf ./$1/netcraft.html ./$1/netcraft.pdf

print "grabbing intodns"
curl "www.intodns.com/$1" > "./$1/intodns.html"
xvfb-run wkhtmltopdf ./$1/intodns.html ./$1/intodns.pdf

print "[?] robtex..."
curl "https://www.robtex.com/?dns=hsbc.com" > "./$1/robtex.html"
xvfb-run xvfb-run wkhtmltopdf ./$1/robtex.html ./$1/robtex.pdf

print "[?] robtex #2..."
curl "https://www.robtex.com/?dns=$1" > "./$1/robtex2.html"
xvfb-run wkhtmltopdf ./$1/robtex2.html ./$1/robtex2.pdf

print "[?] hasemian domain email"
curl "http://www.hashemian.com/tools/domain-email.php?b=$1" > "./$1/domainemail.html"
xvfb-run wkhtmltopdf ./$1/domainemail.html ./$1/domainemail.pdf

print "[?] netcraft..."
curl "http://toolbar.netcraft.com/site_report?url=$1" > "./$1/netcraft.html"
curl "http://toolbar.netcraft.com/site_report?url=$1#last_reboot" > "./$1/netcraft2.html"
xvfb-run wkhtmltopdf ./$1/netcraft.html ./$1/netcraft.pdf
xvfb-run wkhtmltopdf ./$1/netcraft2.html ./$1/netcraft2.pdf

print "[?] pdf finder ..."
curl "https://www.google.com/search?hl=en&q=filetype%3Apdf+site%3A$1" > "./$1/pdf.html"
xvfb-run wkhtmltopdf ./$1/pdf.html ./$1/pdf.pdf
print "[?] subdomain finder ..."

curl "https://www.google.com/search?q=+%22%40$1%22+-www.$1" > "./$1/subdomains.html"
xvfb-run wkhtmltopdf ./$1/subdomains.html ./$1/subdomains.pdf

print "[?] link finder..."
curl "https://www.google.com/search?q=link:www.$1" > "./$1/links.html"
xvfb-run wkhtmltopdf ./$1/links.html ./$1/links.pdf

print "[?] finding xls"
curl "https://www.google.com/search?hl=en&q=filetype%3Axls+OR+filetype%3Axlsx+site%3Awww.$1" > "./$1/xls.html"
xvfb-run wkhtmltopdf ./$1/xls.html ./$1/xls.pdf

print "[?] finding ppt"
curl "https://www.google.com/search?hl=en&q=filetype%3Appt+OR+filetype%3Apptx+site%3Awww.$1" > "./$1/ppt.html"
xvfb-run wkhtmltopdf ./$1/ppt.html ./$1/ppt.pdf

print "[?] finding .doc files"
curl "https://www.google.com/search?hl=en&q=filetype%3Adoc+OR+filetype%3Adocx+site%3Aww.$1" > "./$1/doc.html"
xvfb-run wkhtmltopdf ./$1/doc.html ./$1/doc.pdf

print "[?] finding .xls files"
xvfb-run wkhtmltopdf ./$1/xls.html ./$1/xls.pdf
curl "https://www.google.com/search?h1=en&q=filetype%3Axls+OR+filetype%3Appt+OR+filetype%3Adoc+site%3Awww.$1" > "./$1/xls.html"

print "[?] finding .xlsx files"
curl "https://www.google.com/search?h1=en&q=filetype%3Axlsx+OR+filetype%3Apptx+OR+filetype%3Adocx+site%3Awww.$1" > "./$1/xlsx.html"
xvfb-run wkhtmltopdf ./$1/xlsx.html ./$1/xlsx.pdf

print "[?] finding subdomains"
curl "https://www.google.com/search?hl=en&q=site%3Ahsbc.com+-www.$1 #subdomains" > "./$1/subdomains2.html"
xvfb-run wkhtmltopdf ./$1/subdomains2.html ./$1/subdomains.pdf

print "[?] finding .txt files"
curl "https://www.google.com/search?hl=en&q=filetype%3Atxt+site%3Awww.$1" > "./$1/txt.html"
xvfb-run wkhtmltopdf ./$1/txt.html ./$1/txt.pdf

print "[?] finding domaindossier via centralops"
curl "http://centralops.net/co/DomainDossier.aspx?dom_whois=true&dom_dns=true&traceroute=true&net_whois=true&svc_scan=true&x=15&y=11&addr=$1" > "./$1/domaindossier.html"
xvfb-run wkhtmltopdf ./$1/xls.html ./$1/domaindossier.pdf

print "[?] network-tools network test"
curl "http://network-tools.com/default.asp?prog=network&host=www.$1" > "./$1/networktools.html"
xvfb-run wkhtmltopdf ./$1/networktools.html ./$1/networktools.pdf

print "[?] network-tools trace route"
curl "http://network-tools.com/default.asp?prog=trace&host=www.$1" > "./$1/networktrace.html"
xvfb-run wkhtmltopdf ./$1/networktrace.html ./$1/networktrace.pdf

print "[?] whois.domains.tools.com query"
curl "http://whois.domaintools.com/$1" > "./$1/whois.html"
xvfb-run wkhtmltopdf ./$1/whois.html ./$1/whois.pdf

# social

# use recon-ng automation
