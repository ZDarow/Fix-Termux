#!/bin/bash
#this script by Ahmed Alaa
# Fixed version by Qwen Code

red='\e[1;31m'
green='\e[1;32m'
blue='\e[1;34m'
purple='\e[1;35m'
cyan='\e[1;36m'
white='\e[1;37m'
yellow='\e[1;33m'
clear

echo -e $green "#################################################################################################################################################################################################"
echo -e $green "##						                                        			          00  								       ##"
echo -e $green "##   0088################      ############                                       888888888888888888           88        00                         				               ##"
echo -e $green "##   0088################          ####                                           888888888888888888           88      88                             				               ##"
echo -e $green "##   0088                          ####      00          00                             88        8888         88    99            99          00                       00          00         ##"
echo -e $green "##   0088################          ####        00      00                               88       88   88       88 999       88    88 88         88      88     00         00 	  00           ##"
echo -e $green "##   0088################          ####          00  00                                 88     88      88      88d          99  88    00    00    00    00     00           00  00             ##"
echo -e $green "##   8888			   ####            00         ##################        88   88	 88      88    88           88 00      00  00     000   00     00             00               ##"
echo -e $green "##   8888			   ####          00  00       ##################        88    88 88888  88     88           999         00          00   00 00  00          00   00            ##"
echo -e $green "##   8888			   ####        00      00                               88    88	       88           88           88           88                       00      00       00          ##"
echo -e $green "##   0088                          ####      00          00                             88     88  888888      88                                                       00           00        ##"
echo -e $green "##   0088                          ####                    00                           88      88             88    						      00               00      ##"
echo -e $green "##   0088                      ############                                             88   	8888888	       88							                       ##"
echo -e $green "###################################################################################  Haram-Masr #################################################################################################"
echo ""
echo -e $red     "What useing?"
echo
echo -e $green   "1- Linux & Gnuroot"
echo
echo -e $green   "2- Termux"
echo
echo -e $green   "3- Metaspoloit"
echo
echo -e $green   "4- all information gatherin on kali"
echo
echo -e $green   "5- ngrok"
echo
echo -e $green   "6- Termux-Alpine"
echo
echo -e $green   "7- Termux-Fedora"
echo
echo -e $green   "0- Exit"
read use

# Опция 1: Linux & Gnuroot
if [ $use = 1 ]
then
    apt-get update
    apt-get upgrade -y
    apt-get install figlet -y
    apt-get install git -y
    apt-get install wget -y
    apt-get install toilet -y
    apt-get install lolcat -y
    apt-get install ruby -y
    gem install figlet
    apt-get install nano -y
    apt-get install termux-api -y
    pip install youtube-dl
fi

# Опция 2: Termux
if [ $use = 2 ]
then
    apt update && apt upgrade -y
    pkg install git -y
    pkg install python -y
    pkg install python2 -y
    pkg install figlet -y
    pkg install wget -y
    pkg install root-repo -y
    pkg install unstable-repo -y
    pkg install x11-repo -y
    pkg install ruby -y
    pkg install nano -y
    pkg install toilet -y
    pkg install locate -y
    gem install figlet
    pip install wordlist
    pkg install termux-api -y
    pkg install ncurses-utils -y
    pip install youtube-dl
    pkg install golang -y
    pkg install php -y
    pkg install cmatrix -y
    pkg install cowsay -y
    pkg install openssh -y
    pkg install unzip -y
    pkg install tor -y
    pkg install tar -y
    pkg install net-tools -y
    pkg install zip -y
    pkg install unrar -y
    pkg install clang -y
    pkg install w3m -y
    pkg install proot -y
    pip install wget
    pip install --upgrade pip
    pip install requests
    pip install mechanize
    pkg install python2-dev -y
    pkg install mariadb -y
    pkg install man -y
    pkg install texinfo -y
    pip install argument
    pkg install graphviz -y
    pkg install tty-clock -y
    gem install bundler
fi

# Опция 3: Metasploit
if [ $use = 3 ]
then
    cd $HOME
    pkg install unstable-repo -y
    pkg install metasploit -y
    apt -f install -y
fi

# Опция 4: Kali Information Gathering
if [ $use = 4 ]
then
    apt update
    apt install -y ace apt2 arp-scan bing-ip2hosts braa maltego cdpsnarf cisco-torch dmitry
    apt install -y dnsenum dnsmap dnsrecon dnstracer dnswalk dotdotpwn enum4linux enumiax
    apt install -y faraday fierce firewalk goofile hping3 ident-user-enum inspy intrace ismtp lbd
    apt install -y masscan metagoofil nbtscan-unixwiz nikto p0f parsero recon-ng smbmap smtp-user-enum
    apt install -y sslsplit sublist3r theharvester tlssled twofi unicornscan urlcrazy wireshark
    
    # Git clone с проверкой
    git clone https://github.com/pro-root/dnmap || echo "dnmap: clone failed"
    git clone https://github.com/FortyNorthSecurity/EyeWitness.git || echo "EyeWitness: clone failed"
    git clone https://github.com/savio-code/ghost-phisher.git || echo "ghost-phisher: clone failed"
    git clone https://github.com/golismero/golismero.git || echo "golismero: clone failed"
    git clone https://github.com/i3visio/osrframework.git || echo "osrframework: clone failed"
    git clone https://github.com/trustedsec/social-engineer-toolkit.git || echo "SET: clone failed"
    git clone https://github.com/secforce/sparta.git || echo "sparta: clone failed"
    git clone -b release_1_0 https://github.com/grwl/sslcaudit.git || echo "sslcaudit: clone failed"
fi

# Опция 5: Ngrok
if [ $use = 5 ]
then
    echo "soon"
fi

# Опция 6: Termux-Alpine
if [ $use = 6 ]
then
    cd $HOME
    apt update && apt upgrade -y
    apt install curl proot wget ruby -y
    curl -LO https://raw.githubusercontent.com/Hax4us/TermuxAlpine/master/TermuxAlpine.sh
    chmod 777 TermuxAlpine.sh
    ./TermuxAlpine.sh
    startalpine
fi

# Опция 7: Termux-Fedora
if [ $use = 7 ]
then
    echo "soon"
fi

# Опция 0: Exit
if [ $use = 0 ]
then
    clear
    exit
fi
