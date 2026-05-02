# custom-docker-action 
# we are creating a github actions + docker + nodejs + giphy
# why ?
# users want to add be able to commment giphys on chat 
## how to do that?
## chat request giphy > github actions + nodejs + docker gets the request >> sends a api to giphy >> giphy gets the image and returns it>> github actions + docker + nodejs pushes the request back to chat >> chat recives the image 

## how to get rest api of giphy ##
# 1. create giphy.com account 
# 2. create sdk or api key >> give name >> web >> nodejs >> discription 
# 3. go to developers.giphy >> api explorer >> use created api
# Choose an app / API Key: choose api key / sdk
# Choose a resource: public api 
# Choose an endpoint random
# Request URL: generates random giphys url
# --------------------------------------------------------------------

# Container image that runs your code
FROM alpine:3.10

# # Install necessary packages
RUN apk update && \
    apk add --no-cache curl jq

# Copy your entrypoint script to the container file path
COPY entrypoint.sh /entrypoint.sh

# Make the script executable
RUN chmod +x /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]


## whats happening in the build ###
# 1. ubuntu docker image is storing the code 
# 2. installing the depenencies 
# 3.curl for making api calls to get giphy , jq library for parting the urls 
# 4. entrypoint.sh contains the logic for calling the giphy api, it filters the response makes a call to the rest api and post the comment
# 5. chmod makes it a executable .sh (shell script)
# 6. it executes that shell script with entrypoint command 
# 7. make a new file .sh for entrypoint, its the source code of docker file 

#custom docker actions it only uses ubuntu 
    