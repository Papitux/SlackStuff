config() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "$(cat $OLD | md5sum)" = "$(cat $NEW | md5sum)" ]; then
    rm $NEW
  fi
}
config etc/qbt-nox/qbt-nox.conf.new

preserve_perms() {
  NEW="$1"
  OLD="$(dirname ${NEW})/$(basename ${NEW} .new)"
  if [ -e ${OLD} ]; then
    cp -a ${OLD} ${NEW}.incoming
    cat ${NEW} > ${NEW}.incoming
    mv ${NEW}.incoming ${NEW}
  fi
  config ${NEW}
}
#preserve_perms etc/rc.d/rc.qbt-nox.new

if [ -r etc/rc.d/rc.qbt-nox -a -r etc/rc.d/rc.qbt-nox.new ]; then
  chmod --reference=etc/rc.d/rc.qbt-nox etc/rc.d/rc.qbt-nox.new
fi
mv etc/rc.d/rc.qbt-nox.new etc/rc.d/rc.qbt-nox

# Add qbt-nox user/group
export FREE_UID=`tail -1 /etc/passwd |awk -F : '{print $3 + 1}'`
export FREE_GUID=`tail -1 /etc/group |awk -F : '{print $3 + 1}'`
export QBTD_USER=qbt-nox
export QBTD_GROUP=qbt-nox

if ! grep --quiet '^qbt-nox:' /etc/group ;then
  echo -e "Creating new group qbt-nox..." 1>&2
           /usr/sbin/groupadd \
          -g $FREE_GUID \
           $QBTD_GROUP 2> /dev/null
else
 if grep --quiet '^qbt-nox:' /etc/group ;then
   echo -e "Group already exist or error creating new group..." 1>&2
 fi
fi

if ! grep --quiet '^qbt-nox:' /etc/passwd ;then
  echo -e "Creating unprivileged user..." 1>&2
           /usr/sbin/useradd \
          -d /var/lib/qbt-nox \
          -c "BitTorrent Daemon" \
          -u $FREE_UID \
          -s /bin/false \
          -g $QBTD_GROUP \
           $QBTD_USER 2> /dev/null
           usermod -a -G $QBTD_GROUP $QBTD_USER 2> /dev/null
else
 if grep --quiet '^qbt-nox:' /etc/passwd ;then
   echo -e "User already exist or error creating unprivileged user..." 1>&2
 fi
fi

if grep --quiet '^qbt-nox:' /etc/group && \
    grep --quiet '^qbt-nox:' /etc/passwd && \
     [ -f /bin/chown ]; then
  echo -e "Granting permissions to user qbt-nox..."  1>&2
  /bin/chown -R qbt-nox:qbt-nox /var/lib/qbt-nox
  /bin/chown -R qbt-nox:qbt-nox /var/lock/qbt-nox
else
  echo -e "Error granting permissions!"  1>&2
fi

# Add qbt-nox to rc.local
echo "Adding rc.qbt-nox entry in rc.local..."
if [ ! -f /etc/rc.d/rc.local ]; then
  echo "Nothing to do: /etc/rc.d/rc.local not found"
else
 if ! grep -q "rc.qbt-nox start" /etc/rc.d/rc.local && \
  grep --quiet '^qbt-nox:' /etc/passwd && \
   grep --quiet '^qbt-nox:' /etc/group; then
cat >> /etc/rc.d/rc.local << EOF

# Start the qBittorrent BitTorrent daemon.
if [ -x /etc/rc.d/rc.qbt-nox ]; then
  sh /etc/rc.d/rc.qbt-nox start
fi

EOF
echo "New entry added in rc.local"
else
  echo "Nothing to do: rc.qbt-nox already in /etc/rc.d/rc.local"
 fi
fi

echo "Adding rc.qbt-nox entry in rc.local.shutdown..."
if [ ! -f /etc/rc.d/rc.local_shutdown ]; then
  echo "Nothing to do: /etc/rc.d/rc.local_shutdown not found"
else
 if ! grep -q "rc.qbt-nox stop" /etc/rc.d/rc.local_shutdown  && \
  grep --quiet '^qbt-nox:' /etc/passwd && \
   grep --quiet '^qbt-nox:' /etc/group; then
cat >> /etc/rc.d/rc.local_shutdown << EOF

# Stop the qBittorrent-nox BitTorrent daemon.
if [ -x /etc/rc.d/rc.qbt-nox ]; then
  sh /etc/rc.d/rc.qbt-nox stop
fi

EOF
echo "New entry added in rc.local_shutdown"
 else
  echo "Nothing to do: rc.qbt-nox already in /etc/rc.d/rc.local_shutdown"
 fi
fi

# Some pimp
if [ -f /usr/bin/tput ] && \
   grep --quiet '^qbt-nox:' /etc/passwd && \
    grep --quiet '^qbt-nox:' /etc/group && \
     grep -q "rc.qbt-nox start" /etc/rc.d/rc.local; then
  /usr/bin/tput bold
  echo ""
  echo "qbt-nox will run as:"
  echo ""
  echo "User: qbt-nox"
  echo "User ID: [`grep '^qbt-nox:' /etc/passwd | awk -F : '{print $3}'`]"
  echo "Group: qbt-nox"
  echo "Group ID: [`grep '^qbt-nox:' /etc/group | awk -F : '{print $3}'`]"
  echo "Home: /var/lib/qbt-nox"
  echo "Login shell: /bin/false"
  echo "Real name: BitTorrent Daemon"
  echo "Expire date: never"
  echo "Password: _blank_"
  echo ""
  /usr/bin/tput sgr0
else
 if grep --quiet '^qbt-nox:' /etc/passwd && \
     grep --quiet '^qbt-nox:' /etc/group && \
      grep -q "rc.qbt-nox start" /etc/rc.d/rc.local; then
  echo ""
  echo "qbt-nox will run as:"
  echo ""
  echo "User: qbt-nox"
  echo "User ID: [`grep '^qbt-nox:' /etc/passwd | awk -F : '{print $3}'`]"
  echo "Group: qbt-nox"
  echo "Group ID: [`grep '^qbt-nox:' /etc/group | awk -F : '{print $3}'`]"
  echo "Home: /var/lib/qbt-nox"
  echo "Login shell: /bin/false"
  echo "Real name: BitTorrent Daemon"
  echo "Expire date: never"
  echo "Password: _blank_"
  echo ""
 fi
fi
