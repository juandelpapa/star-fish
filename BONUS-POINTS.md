# Cloudwatch monitoring

Unable to complete this.  I would look at defining a monitor on the LB health check and use that to alert when unable to connect to port 22

# Host as a bastion host function

Leave the host in the public subnet, put other hosts in a private subnet and restrict access from the public to the private using security groups and/or NACLs.