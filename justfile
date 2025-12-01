
set dotenv-load := true

session_token := env("AOC_Session")

test:
    @echo $AOC_Session

get-input year day:
    @curl 'https://adventofcode.com/{{year}}/day/{{day}}/input' \
            -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8' \
            -b 'session={{session_token}}' \
            -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'
