#!/bin/bash

# Set Vars
dns_conf_dir="/etc/bind"
dns_conf_file="/etc/bind/named.conf"
zone_file="zone.default"
default_file="named.default"
db_file="db.default"
target_dir=target

# Create Backup files
cp "$zone_file" "${zone_file}.backup"
cp "$default_file" "${default_file}.backup"
cp "$db_file" "${db_file}.backup"

# Load Parameters from "env.conf"
readarray -t params <<< $(cut -d '#' -f 1 "env.conf" | sed "s/ //g")
net_reverse=$(echo "${params[2]}" | awk -F. '{print $4"."$3"."$2"."$1}')
net_reverse=${net_reverse#*.}

# Get End IP block of Servers
end_nsIP=$(echo "${params[1]}" | cut -d '.' -f4)
end_webIP=$(echo "${params[2]}" | cut -d '.' -f4)

# Update files
sed -i "s|domain_name|${params[0]}|" "$zone_file"
sed -i "s|domain_file|${params[0]}|" "$zone_file"
sed -i "s|ip_net_reverse|$net_reverse|" "$zone_file"
sed -i "s|domaine_revert_file|db.${params[0]}|" "$zone_file"

sed -i "s|nameserver|ns.${params[0]}.|" "$default_file"
sed -i "s|email|root.${params[0]}.|" "$default_file"
sed -i "s|ip_domain_server|${params[1]}|" "$default_file"
sed -i "s|ip_web_server|${params[2]}|" "$default_file"

sed -i "s|nameserver|ns.${params[0]}.|" "$db_file"
sed -i "s|email|root.${params[0]}.|" "$db_file"
sed -i "s|webserver|www.${params[0]}.|" "$db_file"
sed -i "s|end_nsIP|$end_nsIP|" "$db_file"
sed -i "s|end_webIP|$end_webIP|" "$db_file"

# Move files to target folder
[[ ! -d "$target_dir" ]] && mkdir $target_dir 
mv "$zone_file" "$target_dir/zone.${params[0]}"
mv "$default_file" "$target_dir/${params[0]}"
mv "$db_file" "$target_dir/db.${params[0]}"

# Copy Suzano config to DNS Config Directory (/etc/bind/)
#cat "$target_dir/zone.conf.local" >> "$dns_conf_dir/named.conf.local"

cp "$target_dir/zone.${params[0]}" "$dns_conf_dir"
cp "$target_dir/${params[0]}" "$dns_conf_dir"
cp "$target_dir/db.${params[0]}" "$dns_conf_dir"

mv "${zone_file}.backup" "$zone_file"
mv "${default_file}.backup" "$default_file"
mv "${db_file}.backup" "$db_file"

# Edit DNS config file and Restart DNS service

grep -q "zone.${params[0]}" "$dns_conf_file" 
[[ $? -eq 1 ]] && echo "include \"$dns_conf_dir/zone.${params[0]}\";" >> "$dns_conf_file"

service named reload

