# Use a small base image with curl + jq
FROM alpine:3.19

# Install required tools
RUN apk add --no-cache curl jq

# Copy your DESTRUCTION script into the container
COPY run-destroy.sh /run-destroy.sh  
RUN chmod +x /run-destroy.sh

# Run destruction script by default
CMD ["/run-destroy.sh"]              
