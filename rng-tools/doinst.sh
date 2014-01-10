config() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "$(cat $OLD | md5sum)" = "$(cat $NEW | md5sum)" ]; then
    rm $NEW
  fi
}
config etc/rngd/rngd.conf.new

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

if [ -r etc/rc.d/rc.rngd -a -r etc/rc.d/rc.rngd.new ]; then
  chmod --reference=etc/rc.d/rc.rngd etc/rc.d/rc.rngd.new
fi
mv etc/rc.d/rc.rngd.new etc/rc.d/rc.rngd

# Add to rc.local
echo "Adding rc.rngd entry in rc.local..."
if [ ! -f /etc/rc.d/rc.local ]; then
  echo "Nothing to do: /etc/rc.d/rc.local not found"
else
 if ! grep -q "rc.rngd start" /etc/rc.d/rc.local ; then
cat >> /etc/rc.d/rc.local << EOF

# Start the Random Number Generator Daemon (rngd).
if [ -x /etc/rc.d/rc.rngd ]; then
  sh /etc/rc.d/rc.rngd start
fi

EOF
echo "New entry added in rc.local"
else
  echo "Nothing to do: rc.rngd already in /etc/rc.d/rc.local"
 fi
fi

echo "Adding rc.rngd entry in rc.local.shutdown..."
if [ ! -f /etc/rc.d/rc.local_shutdown ]; then
  echo "Nothing to do: /etc/rc.d/rc.local_shutdown not found"
else
 if ! grep -q "rc.rngd stop" /etc/rc.d/rc.local_shutdown ; then
cat >> /etc/rc.d/rc.local_shutdown << EOF

# Stop the Random Number Generator Daemon (rngd).
if [ -x /etc/rc.d/rc.rngd ]; then
  sh /etc/rc.d/rc.rngd stop
fi

EOF
echo "New entry added in rc.local_shutdown"
 else
  echo "Nothing to do: rc.rngd already in /etc/rc.d/rc.local_shutdown"
 fi
fi
