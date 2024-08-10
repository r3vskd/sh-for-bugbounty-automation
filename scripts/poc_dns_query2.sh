arr=( $MX )
for ((i=1; i<${#arr[@]}; i+=2)); do dig A +short "${arr[i]}"; done

