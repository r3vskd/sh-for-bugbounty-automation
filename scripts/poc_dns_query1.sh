#!/bin/bash
# Bulk DNS Lookup
# Generates a CSV of DNS lookups from a list of domains.
#
# File name/path of domain list:
domain_list='domains.txt' # One FQDN per line in file.
#
# IP address of the nameserver used for lookups:
ns_ip='1.1.1.1' # Is using Cloudflare's 1.1.1.1.
#
# Seconds to wait between lookups:
loop_wait='1' # Is set to 1 second.

echo 'Domain name, IP Address, IP PTR, IP NetName (WHOIS)' # Start CSV
for domain in $(cat $domain_list) # Start looping through domains
do
    ip=$(dig @$ns_ip +short $domain | tail -n1) # IP address lookup
    if [ -z "$ip" ] # If the IP is null (expired or invalid domain)
        then # Then
            echo "$domain,No DNS,," # Write "No DNS" in the IP column
        else # And if an IP is found perform a PTR and NetName lookup
            echo -en "$domain,$ip,"$(dig @$ns_ip +short -x $ip | xargs)','
            whois $ip | grep -i 'netname' | awk '{print $NF}' | xargs
    fi
    sleep $loop_wait # Pause before the next lookup to avoid flooding NS
done
