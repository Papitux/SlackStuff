config() {
  for infile in $1; do
    NEW="$infile"
    OLD="$(dirname $NEW)/$(basename $NEW .new)"
    if [ ! -r $OLD ]; then
      mv $NEW $OLD
    elif [ "$(cat $OLD | md5sum)" = "$(cat $NEW | md5sum)" ]; then
      rm $NEW
    fi
  done
}
config etc/nftables/ipv4-nat.new
config etc/nftables/ipv6-nat.new
config etc/nftables/ipv4-filter.new
config etc/nftables/ipv4-mangle.new
config etc/nftables/ipv6-filter.new
config etc/nftables/ipv6-mangle.new
config etc/nftables/bridge-filter.new
