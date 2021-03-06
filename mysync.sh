#!/bin/bash

if [ ! -d mysync_data ]; then
   echo No mysync_data directory, creating directory
   mkdir -p mysync_data
fi

if [ ! -d mysync_data_enc ]; then
   echo No mysync_data_env directory, creating directory
   mkdir -p mysync_data_enc
fi

if [ ! -d pems ]; then
   echo No pems directory, creating directory
   echo Must obtain the pemfile and place in this dir
   echo Have someone run ./mysync.sh encrypt_pem
   echo and send that encrypted pem to you to put in pems directory
   echo The run ./mysync.sh decrypt_pem
   echo They will have to send you the decryption password
   echo We recommend the site https://onetimesecret.com for that
   mkdir -p pems
fi

if [ -f mysync_config ]; then
   source mysync_config
   chmod 400 pems/$pem_file
else
   echo Need to create a mysync_config file. See the Readme.
   exit 1
fi

if [ $# -eq 0 ]; then
   exit 1
fi


encrypt_pem () {
   openssl aes-256-cbc -a -salt -in pems/${pem_file} -out pems/${pem_file}.enc
}

decrypt_pem () {
   openssl aes-256-cbc -d -a -in pems/${pem_file}.enc -out pems/${pem_file}
   chmod 0400 pems/${pem_file}
}

encrypt_config () {
   openssl aes-256-cbc -a -salt -in mysync_config -out mysync_config.enc
}

decrypt_config () {
   openssl aes-256-cbc -d -a -in mysync_config.enc -out mysync_config
   chmod 0400 pems/${pem_file}
}

encrypt () {
   openssl aes-256-cbc -a -salt -in mysync_data/${1} -out mysync_data_enc/${1}.enc
}

decrypt () {
   openssl aes-256-cbc -d -a -in mysync_data_enc/${1}.enc -out mysync_data/$1
}

cmd=$1

if [ $cmd == 'help' ]; then
   echo -Syntax: ./mysync cmd
   echo commands are [list|push|pull|encrypt|decrypt|encrypt_pem]
   exit 1
elif [ $cmd == 'list' ]; then
   ls mysync_data
elif [ $cmd == 'encrypt' ]; then
   file=$2
   encrypt $file
elif [ $cmd == 'decrypt' ]; then
   file=$2
   decrypt $file
elif [ $cmd == 'encrypt_pem' ]; then
    encrypt_pem
elif [ $cmd == 'decrypt_pem' ]; then
     decrypt_pem
elif [ $cmd == 'encrypt_config' ]; then
     encrypt_config
elif [ $cmd == 'decrypt_condif' ]; then
      decrypt_config
elif [ $cmd == push ]; then
   file=$2
   encrypt $file
   rsync -rave "ssh -i pems/${pem_file}" mysync_data_enc/${file}.enc ${user}@${ip}:mysync/mysync_data_enc
elif [ $cmd == pull ]; then
   file=$2
   if [ -z $file ]; then
      file='*'
   fi
   rsync -rave "ssh -i pems/${pem_file}" ${user}@${ip}:mysync/mysync_data_enc/${file}.enc mysync_data_enc
elif [ $cmd == list_remote ]; then
   ssh -i pems/${pem_file} ${user}@${ip} ls mysync/mysync_data_enc
elif [ $cmd == clear_remote ]; then
    echo removing remote data
    ssh -i pems/${pem_file} ${user}@${ip} rm -f mysync/mysync_data/\*
    ssh -i pems/${pem_file} ${user}@${ip} rm -f mysync/mysync_data_enc/\*
elif [ $cmd == clear_local ]; then
    echo removing local data
    rm -f mysync/mysync_data/*
    rm -f mysync/mysync_data_enc/*
else
   echo Command $cmd not
fi
