#!/usr/bin/bash
/usr/local/bin/po4a ${*} 2&> /root/po4a_log
cat /root/po4a_log
