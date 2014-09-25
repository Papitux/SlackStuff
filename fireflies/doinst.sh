# Some pimp
if [ -f /usr/bin/tput ]; then
  /usr/bin/tput bold
  echo ""
  echo "To add Fireflies 3D into your active screensavers, execute:"
  echo "perl /usr/libexec/xscreensaver/fireflies_install.pl"
  echo ""
  /usr/bin/tput sgr0
else
  echo ""
  echo "To add Fireflies 3D into your active screensavers, execute:"
  echo "perl /usr/libexec/xscreensaver/fireflies_install.pl"
  echo ""
fi