# Automatic configuration of DNS server

## Description

<ul>
    <li> <em><b>setup-dns.sh</b></em> is the main file to be execute</li>
    <li> <em><b>env.conf</b></em> this file contains values ​​used to generate DNS configuration files</li>
    <li> <em><b>named.default</b></em> is DNS database zone file</li>
    <li> <em><b>db.default</b></em> is a reverse DNS database zone file </li>
    <li> <em><b>zone.default</b></em> is the configuration file used to define DNS zones</li>
</ul>

## Pre-requise

1.  Set your own value in <b>env.conf</b> file.
2.  Make sur that you have DNS service installed`(Bind9)

## How to use ?

```
sudo ./setup-dns.sh 
```
