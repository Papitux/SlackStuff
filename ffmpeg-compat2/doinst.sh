if ! cat /etc/ld.so.conf | grep 'ffmpeg-compat2' > /dev/null; then
    echo -e '/usr/lib64/ffmpeg-compat2' >> /etc/ld.so.conf
fi
