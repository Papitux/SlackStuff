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

config etc/ConsoleKit/seats.d/00-primary.seat.new
config etc/polkit-1/rules.d/10-disks.rules.new
config etc/polkit-1/rules.d/10-hibernate.rules.new
config etc/polkit-1/rules.d/10-hybridsleep.rules.new
config etc/polkit-1/rules.d/10-nm.rules.new
config etc/polkit-1/rules.d/10-restart.rules.new
config etc/polkit-1/rules.d/10-shutdown.rules.new
config etc/polkit-1/rules.d/10-suspend.rules.new
preserve_perms etc/rc.d/rc.consolekit.new

