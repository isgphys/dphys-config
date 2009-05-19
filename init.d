#!/bin/sh
# /etc/init.d/dphys-config - boot time trigger automatic config updates
# authors dsbg and franklin, last modification 2006.09.15
# copyright ETH Zuerich Physics Departement
#   use under either modified/non-advertising BSD or GPL license

# this init.d script is intended to be run from rc2.d
#   on our site it needs to run after rc2.d/S20inetd (and so identd)
#     else our config file server will disallow requests for config files
#   on our site it needs to run before rc2.d/S24dphys-admin
#     else that will not find its /etc/dphys-admin.list config file
#   so we run it as rc2.d/S22dphys-config

### BEGIN INIT INFO
# Provides:          dphys-config
# Required-Start:    $syslog
# Required-Stop:     $syslog
# Should-Start:      $local_fs
# Should-Stop:       $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      
# Short-Description: Fetch and merge config files, run scripts when they change
# Description:       Tool to get a list of config files, and for each file
#                    in that list retrieve it from same server and install
#                    it if not yet there.
### END INIT INFO

PATH=/sbin:/bin:/usr/sbin:/usr/bin
export PATH

# what we are
NAME=dphys-config

case "$1" in

  start)
    /bin/echo "Starting ${NAME} automatic config updates ..."

    # in case system was switched off for a while, run an upgrade
    #   this will produce output, so no -n in above echo
    /usr/bin/dphys-config init

    /bin/echo "done."
    ;;

  stop|default-stop)
    /bin/echo "'Stopping' ${NAME} automatic config updates (does nothing)."
    ;;

  restart|reload|force-reload)
    /bin/echo "No daemon to (force-)re[start|load] in ${NAME}"
    ;;

  *)
    /bin/echo "Usage: $0 {start}"

    exit 1
    ;;

esac

exit 0
