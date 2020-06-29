#!/bin/bash

listLink=$(curl -s 'https://data.gov.il/dataset/degem-rechev-wltp' -H 'authority: data.gov.il' -H 'upgrade-insecure-requests: 1' -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36 Edg/83.0.478.56' -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'sec-fetch-site: none' -H 'sec-fetch-mode: navigate' -H 'sec-fetch-dest: document' -H 'accept-language: en-US,en;q=0.9,he;q=0.8' -H 'cookie: wcag-cookie-temp-data.gov.il=true; _ga=GA1.3.833494461.1592985525; rbzid=eDN1X55IKp8ymdzbdMcIZZMaFoPff/7UzCOgRVI5mqUMrkwcAP5cFQZFJfHM3yy8M+1FrhwK3xcxc+N+FkRm5Du2yMJINCw7Ovuy9dNQenQ61bbhTo+SirjH7hWMOGJtGNiyNorUho2j9cKU3Xx073/6le26Xzj4XDjqNZAiczoR3QgBeCGtAJeZNgWMLnDsbHdw0BDKFUkUSLkroB7BoeWL3muFhLrmxWS8umX7RQ15tKphzscMAJpup52CDYwOoEhD8nXbGcsqsE0t8x+IF0RAP1atdYhKmEjv8AYFZjOAe7a+SlIp18ztv3IYiqxP; rbzsessionid=6dd5b0804081affbf6fffe72247ce023; _gid=GA1.3.2061636900.1593418462' | grep ".csv" | grep "href" | cut -d'"' -f2 | grep "142afde2" | tail -1)

if ! [[ -z "$listLink" ]]; then
        curl -s 'https://data.gov.il/'.$listLink.'' -H 'authority: data.gov.il' -H 'upgrade-insecure-requests: 1' -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36 Edg/83.0.478.56' -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'sec-fetch-site: none' -H 'sec-fetch-mode: navigate' -H 'sec-fetch-dest: document' -H 'accept-language: en-US,en;q=0.9,he;q=0.8' -H 'cookie: wcag-cookie-temp-data.gov.il=true; _ga=GA1.3.833494461.1592985525; rbzid=eDN1X55IKp8ymdzbdMcIZZMaFoPff/7UzCOgRVI5mqUMrkwcAP5cFQZFJfHM3yy8M+1FrhwK3xcxc+N+FkRm5Du2yMJINCw7Ovuy9dNQenQ61bbhTo+SirjH7hWMOGJtGNiyNorUho2j9cKU3Xx073/6le26Xzj4XDjqNZAiczoR3QgBeCGtAJeZNgWMLnDsbHdw0BDKFUkUSLkroB7BoeWL3muFhLrmxWS8umX7RQ15tKphzscMAJpup52CDYwOoEhD8nXbGcsqsE0t8x+IF0RAP1atdYhKmEjv8AYFZjOAe7a+SlIp18ztv3IYiqxP; rbzsessionid=6dd5b0804081affbf6fffe72247ce023; _gid=GA1.3.2061636900.1593418462' --compressed > cars/degem.csv
        echo `date "+%d/%m/%Y %H:%M:%S"`" - The degem had been updated." 2>&1 | tee -a log-degem.txt
        exit 0
else
    echo `date "+%d/%m/%Y %H:%M:%S"`" - Error: Can't find the download link." 2>&1 | tee -a log-degem.txt
    exit 1
fi