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

# Keep same perms on rc.webfsd.new:
if [ -e etc/rc.d/rc.webfsd ]; then
  cp -a etc/rc.d/rc.webfsd etc/rc.d/rc.webfsd.new.incoming
  cat etc/rc.d/rc.webfsd.new > etc/rc.d/rc.webfsd.new.incoming
  mv etc/rc.d/rc.webfsd.new.incoming etc/rc.d/rc.webfsd.new
fi
# Then go for it
config etc/rc.d/rc.webfsd.new

# For single config files
config etc/webfs/webfsd.conf.new

