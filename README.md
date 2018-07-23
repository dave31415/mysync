# mysync
Tool for sending and receiving data securely between machine using a remote
server as a rely and rsync. Data is encrypted in transfer by ssh and and
encrypted at rest using a user specified password.

Consists solely of a single bash script which you can and should read.

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

Then copy the pemfile into a directory called pems.

Now run ./mysync.sh with no command. This will create two directories

mysync_data and mysync_data_enc.

The first directory 'mysync_data' is where you put data you want to transfer. The second
directory 'mysync_data_enc' is used by the script as the directory to hold the
encrypted data. Only encrypted data is sent to the remote server.  


Log into the remote server and clone the repo in the home directory there as
well and run ./mysync. Actually all you need there are the directory mysync in
the home directory with the two subdirectories mysync_data and mysync_data_enc.
You can create those my hand or run the script.

Now put some file into the mysync_data directory.

echo hello > mysync_data/hello.txt

Run this to command to see you have a data file there.

./mysync.sh list

You can encrypt this file by running

./mysync.sh encrypt hello.txt

This will prompt for a password. Note that we don't give it a full path.
It's expecting it to be in mysync_data.

Look in mysync_data_enc to see the encrypted file created.

The encryption is done using openssl and will be secure as long as you use a
decent password.

When you push files to the server the encryption will be done automatically
so you don't actually have to encrypt first like this.

You can push your file with

./mysync.sh push hello.txt

Note that it will prompt for a password as before. You will now find the
encrypted file in $HOME/mysync/mysunc_data_enc on the remote server but
not the unencrypted file.

If someone else has setup mysync in the same way, they can get that file by
running

./mysync pull hello.txt

Or if they want all the files, just run

./mysync pull

This will only get them the encrypted files. If they want to decrypt it,
they run

./mysync decrypt hello.txt

and then they will find it decrypted in the mysync_data directory.

For this to work, they need the configuration info and pemfile. There are
commands to encrypt and decrypt those as well.

./mysync encrypt_config

./mysync decrypt_config

./mysync encrypt_pem

./mysync decrypt_pem

Once encrypted with a good password, those can be emailed to someone and
decrypted on their end.

The final bit of security is transferring the password(s) to someone. We
recommend using the website https://onetimesecret.com for this.
