# /etc/cron.d/dphys-config - nightly trigger automatic config updates
# authors dsbg and franklin, last modification 2006.09.15
# copyright ETH Zuerich Physics Departement
#   use under either modified/non-advertising BSD or GPL license

SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# daily early morning autoupgrade of config files of our systems
#   after 03:00, when users are assumed to be least active
#   before 04:00 so that finished long before dphys-admin starts
#     by 1 hour, because random sleep 0..59min to spread load on pkg server
0 3 * * *	root	[ -f /etc/dphys-config -a -x /usr/bin/dphys-config ] && /usr/bin/dphys-config cron > /dev/null 2>&1
