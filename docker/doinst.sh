config() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  # If there's no config file by that name, mv it over:
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "$(cat $OLD | md5sum)" = "$(cat $NEW | md5sum)" ]; then
    # toss the redundant copy
    rm $NEW
  fi
  # Otherwise, we leave the .new copy for the admin to consider...
}

preserve_perms() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  if [ -e $OLD ]; then
    cp -a $OLD ${NEW}.incoming
    cat $NEW > ${NEW}.incoming
    mv ${NEW}.incoming $NEW
  fi
  config $NEW
}

preserve_perms etc/rc.d/rc.docker.new
config etc/docker/docker.conf.new
config etc/logrotate.d/docker.new

# Add docker to rc.local
echo "Adding rc.docker entry in rc.local..."
if [ ! -f /etc/rc.d/rc.local ]; then
  echo "Nothing to do: /etc/rc.d/rc.local not found"
else
 if ! grep -q "rc.docker start" /etc/rc.d/rc.local && \
   grep --quiet '^docker:' /etc/group; then
cat >> /etc/rc.d/rc.local << EOF

# Start the docker daemon.
#if [ -x /etc/rc.d/rc.docker ]; then
#  sh /etc/rc.d/rc.docker start
#fi

EOF
echo "New entry added in rc.local"
else
  echo "Nothing to do: rc.docker already in /etc/rc.d/rc.local"
 fi
fi

echo "Adding rc.docker entry in rc.local.shutdown..."
if [ ! -f /etc/rc.d/rc.local_shutdown ]; then
  echo "Nothing to do: /etc/rc.d/rc.local_shutdown not found"
else
 if ! grep -q "rc.docker stop" /etc/rc.d/rc.local_shutdown  && \
   grep --quiet '^docker:' /etc/group; then
cat >> /etc/rc.d/rc.local_shutdown << EOF

# Stop docker daemon.
#if [ -x /etc/rc.d/rc.docker ]; then
#  sh /etc/rc.d/rc.docker stop
#fi

EOF
echo "New entry added in rc.local_shutdown"
 else
  echo "Nothing to do: rc.docker already in /etc/rc.d/rc.local_shutdown"
 fi
fi

# Some pimp
if [ -f /usr/bin/tput ] && \
    grep --quiet '^docker:' /etc/group && \
     grep -q "rc.docker start" /etc/rc.d/rc.local; then
  /usr/bin/tput bold
  echo ""
  echo "docker will run as:"
  echo ""
  echo "Group: docker"
  echo "Group ID: [`grep '^docker:' /etc/group | awk -F : '{print $3}'`]"
  echo ""
  echo "To use docker as a non-root user,"
  echo "add yourself to the docker group:"
  echo " usermod -a -G docker _username_ "
  echo ""
  /usr/bin/tput sgr0
else
 if grep --quiet '^docker:' /etc/group && \
      grep -q "rc.docker start" /etc/rc.d/rc.local; then
  echo ""
  echo "docker will run as:"
  echo ""
  echo "Group: docker"
  echo "Group ID: [`grep '^docker:' /etc/group | awk -F : '{print $3}'`]"
  echo ""
  echo "To use docker as a non-root user,"
  echo "add yourself to the docker group:"
  echo " usermod -a -G docker _username_ "
  echo ""
 fi
fi
