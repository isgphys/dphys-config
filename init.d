#!/bin/sh
# /etc/init.d/dphys-config - boot time trigger automatic config updates
# authors dsbg, franklin and abe, last modification 2009.06.08
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

if [ -f /etc/default/$NAME ]; then
  . /etc/default/$NAME
fi

chrooted() {
  if [ "${START_INSIDE_CHROOT}" != "yes" ]; then
      if [ -d /proc/1 ]; then
	  if [ `id -u` = 0 ]; then
	      if [ "$(stat -c %d/%i /)" = "$(stat -Lc %d/%i /proc/1/root 2>/dev/null)" ]; then
		  # the devicenumber/inode pair of / is the same as
		  # that of /sbin/init's root, so we're *not* in a
		  # chroot and hence return false
		  return 1
	      else
		  return 0
	      fi
	  else
	      echo "$0: chroot test doesn't work as normal user." >&2;
	      exit 3;
	  fi
      else
	  echo "$0: WARNING: /proc not mounted, assuming chrooted environment." >&2;
	  return 1;
      fi
  fi
  return 0
}

case "$1" in

  start)
    # Don't start inside a chroot.
    if ! chrooted; then
	# Don't start if we don't know where to fetch config updates
	if [ -f /etc/${NAME} ]; then
	    /bin/echo "Starting ${NAME} automatic config updates ..."

            # In case system was switched off for a while, run an
            # upgrade.  This will produce output, so no -n in above
            # echo.
            /usr/bin/dphys-config init
	else
	    /bin/echo "/etc/dphys-config not found. ${NAME} not updating configs ..."
	fi
    else
	/bin/echo "Running inside a chrooted environment. ${NAME} not updating configs ..."
    fi

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
