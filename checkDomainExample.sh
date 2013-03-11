#!/bin/bash
#
# Script helping extract the relevant information from HKDNR WHOIS results
# Can be easily adapted to work with other WHOIS databases
#
# Morgan Aasdam 2013-03-09
#


##
## Data to check against
## N.B. for this example using the domain of the Hong Kong Domain Name Registery
##
declare -a DOMAINS=(
	'hkdnr.hk'
	)
declare -a ACCOUNTS=(
	'HKXXXXXXXT'
	)
	

## Templates assuming the following details are the same for all DOMAINS
##   We are using grep, so you can separate alternative answers with \|
##      i.e: HOLDERNAME="Mary\|John\|Bob" means that the holder name would be valid if the answer is Mary or John or Bob

REGISTRAR="Hong Kong Domain Name Registration Company Limited"
HOLDERNAME="the owner of the domain"
EMAIL="bogus@email.hk"
GIVENNAME="some given name"
FAMILYNAME="and a wrong family name"


##
## Processing the data and outputting results
##

ITERATION=0
echo "################################################################################"
for var in "${DOMAINS[@]}"
do
	echo "$var" | grep --color "$var"
	echo "################################################################################"
	
	## Add the keywords you need to find and highlight in the var below
	## In my case, checking for registration name, registrar and expiry Date
	## This was done because I had some problems with a domain that got transferred to a 3rd party without authorization
	
	WHOISTEXT=`whois $var`
	
	## Helper Function
	validornot(){
		if [ -z "$2" ]
		then
			echo -e -n "\033[31m" ##START RED
			echo -e "INVALID\t\t$1"
			echo -e -n "\033[0m" ##RESET COLORS
		else
			echo -e -n "\033[32m"	##START GREEN
			echo -e "VALID\t\t$2"
			echo -e -n "\033[0m" ##RESET COLORS
		fi	
	}
	
	## Check for Registrar
	echo -e -n "Registrar: \t"
	LONG="`echo \"$WHOISTEXT\" | grep -i -o -m1 'Registrar Name:.*'`"
	SHORT="`echo \"$LONG\" | grep -i -o \"$REGISTRAR\"`"
	validornot "$LONG" "$SHORT"
	
	## Check for Holder English Name
	echo -e -n "Holder Name: \t"
	LONG="`echo \"$WHOISTEXT\" | grep -i -o -m1 'Holder English Name.*'`"
	SHORT="`echo \"$LONG\" | grep -o \"$HOLDERNAME\"`"
	validornot "$LONG" "$SHORT"
	
	## Check for Email
	echo -e -n "Email: \t\t"
	LONG="`echo \"$WHOISTEXT\" | grep -v 'Hotline' | grep -i -o -m1 'Email:.*'`"
	SHORT="`echo \"$LONG\" | grep -o \"$EMAIL\"`"
	validornot "$LONG" "$SHORT"
	
	## Check for Given Name
	echo -e -n "Given Name: \t"
	LONG="`echo \"$WHOISTEXT\" | grep -i -o -m1 'Given name.*'`"
	SHORT="`echo \"$LONG\" | grep -o \"$GIVENNAME\"`"
	validornot "$LONG" "$SHORT"
	
	## Check for Family Name
	echo -e -n "Family Name: \t"
	LONG="`echo \"$WHOISTEXT\" | grep -i -o -m1 'Family name.*'`"
	SHORT="`echo \"$LONG\" | grep -o \"$FAMILYNAME\"`"
	validornot "$LONG" "$SHORT"
	
	## Check for Account Name
	echo -e -n "Account Name: \t"
	LONG="`echo \"$WHOISTEXT\" | grep -i -o -m1 'Account name.*'`"
	SHORT="`echo \"$LONG\" | grep -o \"${ACCOUNTS[$ITERATION]}\"`"
	validornot "$LONG" "$SHORT"
	
	## Display Expiration date
	echo -e -n "Expiration Date: \t\t"
	echo "`echo \"$WHOISTEXT\" | grep -i -o -m1 'Expiry Date.*' | grep -o '[0-9][0-9]\-.*'`"
    
	echo "################################################################################"
	ITERATION=$ITERATION+1
done