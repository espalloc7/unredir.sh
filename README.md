# unredir.sh
this tool designed spesifically for bug hunting purposes. it can send too many requests so **use with caution**.

unredir.sh will filter the scope based on their location header. it will send http get request to every endpoint in the scope. if the response has no 'location' header, it will be added to a new file with the suffix of "_no_redir".

# requirements
to use this script with no errors, you need to have **httpx**(and go obviously) and **parallel** installed on your system. if you have go installed on your system, you can httpx using the command below:
```
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
```
and parallel:
```
sudo apt install parallel
```
# usage
usage of this bash script is simple. give the execution permission to the script file using the command below:
```
chmod +x unredir.sh
```
and run the script:
```
bash unredir.sh
```
