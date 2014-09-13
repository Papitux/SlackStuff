config() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "$(cat $OLD | md5sum)" = "$(cat $NEW | md5sum)" ]; then
    rm $NEW
  fi
}
config etc/darkstat/darkstat.conf.new

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
#preserve_perms etc/rc.d/rc.darkstat.new

if [ -r etc/rc.d/rc.darkstat -a -r etc/rc.d/rc.darkstat.new ]; then
  chmod --reference=etc/rc.d/rc.darkstat etc/rc.d/rc.darkstat.new
fi
mv etc/rc.d/rc.darkstat.new etc/rc.d/rc.darkstat


# Add darkstat to rc.local
echo "Adding rc.darkstat entry in rc.local..."
if [ ! -f /etc/rc.d/rc.local ]; then
  echo "Nothing to do: /etc/rc.d/rc.local not found"
else
 if ! grep -q "rc.darkstat start" /etc/rc.d/rc.local ; then
cat >> /etc/rc.d/rc.local << EOF

# Start the network statistics gatherer daemon (darkstat):
#if [ -x /etc/rc.d/rc.darkstat ]; then
#  sh /etc/rc.d/rc.darkstat start
#fi

EOF
echo "New entry added in rc.local"
else
  echo "Nothing to do: rc.darkstat already in /etc/rc.d/rc.local"
 fi
fi

echo "Adding rc.darkstat entry in rc.local.shutdown..."
if [ ! -f /etc/rc.d/rc.local_shutdown ]; then
  echo "Nothing to do: /etc/rc.d/rc.local_shutdown not found"
else
 if ! grep -q "rc.darkstat stop" /etc/rc.d/rc.local_shutdown ; then
cat >> /etc/rc.d/rc.local_shutdown << EOF

# Stop the network statistics gatherer daemon (darkstat):
#if [ -x /etc/rc.d/rc.darkstat ]; then
#  sh /etc/rc.d/rc.darkstat stop
#fi

EOF
echo "New entry added in rc.local_shutdown"
 else
  echo "Nothing to do: rc.darkstat already in /etc/rc.d/rc.local_shutdown"
 fi
fi
