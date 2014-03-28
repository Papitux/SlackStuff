
if [ -x /sbin/udevadm ]; then
  /sbin/udevadm hwdb --update --root="${ROOT%/}" >/dev/null 2>&1
  /sbin/udevadm control --reload >/dev/null 2>&1
fi
