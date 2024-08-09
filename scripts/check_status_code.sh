#!/bin/bash

# Prompt the user for the wordlist file
read -p "Enter the worldit fiel path: " wordlist

# Check if the wordlist file exists
if [ ! -e "$wordlist" ]; then
    echo "Wordlsit file '$worldist' not found."
    exit 1
fi

# Loop trough the urls in the wordlist and return HTTP status codes
while IFS=read -r url; do
     status_code=$(curl -o /dev/null -s -w "%{http_code}" "$url")
     echo "URL: $url -HTTP status code: $status_code"
done < "$wordlist"
