<?php

if (file_exists('/etc/init.d/protherm')) {
    // Use sysvinit start/stop script to send SIGUSR1 signal.
    system('sudo /etc/init.d/protherm change_mode', $ret);
} else {
    // Uses systemd to send SIGUSR1 signal.
    system('sudo /usr/local/sbin/protherm-sigusr1', $ret);
}
