#!/bin/sh

# Get the GitHub Token and Giphy API Key from GitHub Action inputs
GITHUB_TOKEN=$1
GIPHY_API_KEY=$2

# Get the pull request number from the GitHub event payload
pull_request_number=$(jq --raw-output .pull_request.number "$GITHUB_EVENT_PATH")
echo PR Number - $pull_request_number

# Use the Giphy API to fetch a random Thank You GIF
giphy_response=$(curl -s "https://api.giphy.com/v1/gifs/random?api_key=$GIPHY_API_KEY&tag=thank%20you&rating=g")
echo Giphy Response - $giphy_response

# Extract the GIF URL from the Giphy response
gif_url=$(echo "$giphy_response" | jq --raw-output .data.images.downsized.url)
echo GIPHY_URL - $gif_url

# Create a comment with the GIF on the pull request
comment_response=$(curl -sX POST -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  -d "{\"body\": \"### PR - #$pull_request_number. \n ### 🎉 Thank you for this contribution! \n  ![GIF]($gif_url) \"}" \
  "https://api.github.com/repos/$GITHUB_REPOSITORY/issues/$pull_request_number/comments")

# Extract and print the comment URL from the comment response
comment_url=$(echo "$comment_response" | jq --raw-output .html_url)


## how does it work#
# 1. pass in the token and api_key to the shell script, 2 tokens are reqired of making calls to the rest apis
# 2. you need the know the pull reqest number to post a comment, in the workflow the github event path is important variable that contains the JSON that triggers the workflow new request is raised or opened 
# 2.1 the entire details will be in the github_event_path
# 2.2 in the () jq is only getting the pull request number from github_event_path and echoing it 
# 3. curl is making the call to api path from giphy but [$GIPHY_API_KEY] is in the secrets/inputs we need to get it and we passed a tag thank you so we can only get thank you gifs and keeping rating the same
# 4. get the curl url and use jq to get only the data.images urls 
# 5. make a call to the github rest api using all the post nested $ 
# 6. in the $comment_response jq is only getting the html_url that gets creates the commment with all the $ and some wording 
# 7. make the action
