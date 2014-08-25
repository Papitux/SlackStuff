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

config etc/ca-certificates.conf.new

if [ -x /usr/sbin/update-ca-certificates ]; then
  /usr/sbin/update-ca-certificates --fresh 1> /dev/null 2> /dev/null
fi

CERTS=/etc/ssl/certs

if [ -f $CERTS/ca-certificates.crt ]; then
  if cat $CERTS/ca-certificates.crt | grep '^$' > /dev/null; then
    sed -e '/^$/d;' -i $CERTS/ca-certificates.crt
  fi
fi

if cat $CERTS/ca-certificates.crt | grep 'subject' > /dev/null; then
    sed -e '/^subject/d;' -i $CERTS/ca-certificates.crt
fi

if cat $CERTS/ca-certificates.crt | grep 'issuer' > /dev/null; then
    sed -e '/^issuer/d;' -i $CERTS/ca-certificates.crt
fi
