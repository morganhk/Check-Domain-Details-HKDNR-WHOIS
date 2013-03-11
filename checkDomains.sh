#!/bin/bash
#
# Script helping extract the relevant information from HKDNR WHOIS results
#
# Morgan Aasdam 2013-03-09
#


##
## Input Check
##
if [ $# -lt 1 ]
then
	echo "You need to provide arguments"
	echo "You can run the command as follows: ./scriptName.sh domain1 domain2 domainN"
	echo "or you could do ./scriptName.sh \`cat domainList.txt\`"
	exit 0
fi

##
## Get list of domains  from Argument list
##
## note: You can run the command as follows: ./scriptName.sh domain1 domain2 domainN
##       or you could do ./scriptName.sh `cat domainList.txt`
##

echo "################################################################################"
for var in "$@"
do
	echo "$var" | grep --color "$var"
	echo "################################################################################"
	
	## Add the keywords you need to find and highlight in the var below
	## In my case, checking for registration name, registrar and expiry Date
	## This was done because I had some problems with a domain that got transferred to a 3rd party without authorization
	KEYWORDS="Holder English Name\|Expiry Date:\|Registrar Name: Hong Kong Domain Name Registration Company Limited"
	WHOISTEXT=`whois "$var"`
	
	
    echo "$WHOISTEXT" | grep --color "$KEYWORDS"
    
	echo "################################################################################"
done