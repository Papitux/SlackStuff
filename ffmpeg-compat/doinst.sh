if ! cat /etc/ld.so.conf | grep 'ffmpeg-compat' > /dev/null; then
    echo -e '/usr/lib64/ffmpeg-compat' >> /etc/ld.so.conf
fi
