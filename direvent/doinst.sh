config() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "$(cat $OLD | md5sum)" = "$(cat $NEW | md5sum)" ]; then
    rm $NEW
  fi
}
config etc/direvent/direvent.conf.new

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
#preserve_perms etc/rc.d/rc.direvent.new

if [ -r etc/rc.d/rc.direvent -a -r etc/rc.d/rc.direvent.new ]; then
  chmod --reference=etc/rc.d/rc.direvent etc/rc.d/rc.direvent.new
fi
mv etc/rc.d/rc.direvent.new etc/rc.d/rc.direvent


# Add direvent to rc.local
echo "Adding rc.direvent entry in rc.local..."
if [ ! -f /etc/rc.d/rc.local ]; then
  echo "Nothing to do: /etc/rc.d/rc.local not found"
else
 if ! grep -q "rc.direvent start" /etc/rc.d/rc.local ; then
cat >> /etc/rc.d/rc.local << EOF

# Start the directories events monitor daemon (direvent):
#if [ -x /etc/rc.d/rc.direvent ]; then
#  sh /etc/rc.d/rc.direvent start
#fi

EOF
echo "New entry added in rc.local"
else
  echo "Nothing to do: rc.direvent already in /etc/rc.d/rc.local"
 fi
fi

# Add direvent to rc.local.shutdown
echo "Adding rc.direvent entry in rc.local.shutdown..."
if [ ! -f /etc/rc.d/rc.local_shutdown ]; then
  echo "Nothing to do: /etc/rc.d/rc.local_shutdown not found"
else
 if ! grep -q "rc.direvent stop" /etc/rc.d/rc.local_shutdown ; then
cat >> /etc/rc.d/rc.local_shutdown << EOF

# Stop the directories events monitor daemon (direvent):
#if [ -x /etc/rc.d/rc.direvent ]; then
#  sh /etc/rc.d/rc.direvent stop
#fi

EOF
echo "New entry added in rc.local_shutdown"
 else
  echo "Nothing to do: rc.direvent already in /etc/rc.d/rc.local_shutdown"
 fi
fi
