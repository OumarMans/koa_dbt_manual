# Docker Image for  ELT Process # 

This is the repo for the docker image running all talend etl jobs for telesales on the server.

## How To Update The Jobs ##

In the folder "jobs" you find the exported Talend jobs as .zip files. In order to update the jobs, just put the newly exported .zip files in this folder an make sure to name the files as following:

### Umsatz Mysql ServiceAccount ###

This job queries all the sheets of the different call agent and calculates the revenue, conversion rate etc. per day.

Instructions:

* Run the job: ```Umsatz_Mysql_ServiceAccount/Umsatz_Mysql_ServiceAccount_run.sh --context_param token=/path/to/token.p12``` 

### Bestelliste Innendienst ###

This job queries all the sheets of the different call agent and extracts the orders from it.

Instructions:

* Unzip Bestelliste_Innendienst_0.1.zip
* Run the job: ```Bestelliste_Innendienst_run.sh --context_param token=/path/to/token.p12 xls_path=/path/to/excel_output.xls``` 


### Extra Options for VPN ###

To run the Docker container with openvpn you need to start it with the options ```--cap-add=NET_ADMIN --device /dev/net/tun``` to use the hostsystem tun/tap devices: