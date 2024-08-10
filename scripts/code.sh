#!/bin/bash

domain=$1
wordlist="/home/secret/SecLists/Discovery/DNS/deepmagic.com-prefixes-top500.txt"
resolvers="/home/secret/resolvers.txt"
resolve_domain="/usr/share/sniper/plugins/massdns/bin/massdns -r /usr/share/sniper/plugins/massnds/lists/resolvers.txt -t A -o S -w"

domain_enum(){
    mkdir -p $domain $domain/subdomain $domain/recon $domain/recon/nuclei
    subfinder -d $domain -o $domain/subdomain/subfinder.txt
    amass enum -d $domain -w wordlist -r $resolvers -o $domaim/subdomains/shuffledns.txt
    cat $domain/subdomain*.txt > $domain/subdomain/subdomains/all.txt
}

domain_enum
resolving_domains(){
    shuffledns -d $domain -list $domain/subdomains/all.txt -r $resolvers -o $domain/domains.txt
}

resolving_domains

httprobe(){
    cat $domain/subdomains/all.txt | httpx -threads 200 -o $domain/recon.txt
}
httprobe

scanner(){
    cat $domain/recon.txt | nuclei -t /home/secret/nuclei-temlates/cves/ -c 50 -o $domain/recon/nuclei/cves.txt
    cat $domain/recon.txt | nuclei -t /home/secret/nuclei-templates/vulnerabilities/ -c 50 -o $domain/recon/nuclei/vulnerabilities.txt
    cat $domain/receon.txt | nuclei -t /home/secret/nuclei-templates/files/ -c 50 -o $domain/recon/nuclei/files.txt
}

scanner
