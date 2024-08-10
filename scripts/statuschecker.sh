mydomains=(
domain1
domain2
domain3
)
for i in "${mydomains[@]}"; do dig $i +short; done
