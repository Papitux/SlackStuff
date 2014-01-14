config() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "$(cat $OLD | md5sum)" = "$(cat $NEW | md5sum)" ]; then
    rm $NEW
  fi
}
config etc/twister/twisterd.conf.new

if [ -r etc/rc.d/rc.twister -a -r etc/rc.d/rc.twister.new ]; then
  chmod --reference=etc/rc.d/rc.twister etc/rc.d/rc.twister.new
fi
mv etc/rc.d/rc.twister.new etc/rc.d/rc.twister

# Add to rc.local
echo "Adding rc.twister entry in rc.local..."
if [ ! -f /etc/rc.d/rc.local ]; then
  echo "Nothing to do: /etc/rc.d/rc.local not found"
else
 if ! grep -q "rc.twister start" /etc/rc.d/rc.local ; then
cat >> /etc/rc.d/rc.local << EOF

# Start the p2p microblogging daemon (twisterd).
if [ -x /etc/rc.d/rc.twister ]; then
  sh /etc/rc.d/rc.twister start
fi

EOF
echo "New entry added in rc.local"
else
  echo "Nothing to do: rc.twister already in /etc/rc.d/rc.local"
 fi
fi

echo "Adding rc.twister entry in rc.local.shutdown..."
if [ ! -f /etc/rc.d/rc.local_shutdown ]; then
  echo "Nothing to do: /etc/rc.d/rc.local_shutdown not found"
else
 if ! grep -q "rc.twister stop" /etc/rc.d/rc.local_shutdown ; then
cat >> /etc/rc.d/rc.local_shutdown << EOF

# Stop the p2p microblogging daemon (twisterd).
if [ -x /etc/rc.d/rc.twister ]; then
  sh /etc/rc.d/rc.twister stop
fi

EOF
echo "New entry added in rc.local_shutdown"
 else
  echo "Nothing to do: rc.twister already in /etc/rc.d/rc.local_shutdown"
 fi
fi
