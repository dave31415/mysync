# mysync
Tool for sending and receiving data securely between machine using a remote
server as a rely and rsync. Data is encrypted in transfer by ssh and and
encrypted at rest using a user specified password.

Follow these instructions to use.

You'll need to set up a remote server such as an EC2 instance on AWS and
know the IP address and have a pem file for authorization.

Clone this repo

git clone https://github.com/dave31415/mysync.git
cd mysync

Now create a config file called mysync_config and fill in these details

user=ec2-user

ip=<Your IP address>

pem_file=<name of your pemfile, no path>

Then copy the pemfile into a directory called pems
