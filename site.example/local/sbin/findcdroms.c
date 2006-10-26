#!/usr/bin/tcc -run

/* This code is released for the public domain. Use it for whatever purpose you
 * might find usefull. The code is more or less just a dump of what is available
 * using the ioctl interface in linux
 */
#include <errno.h>
#include <fcntl.h>
#include <linux/cdrom.h>
#include <stdio.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

static void try(const char *path)
{
	int fd;
	if ((fd=open(path, O_RDONLY|O_NONBLOCK))>=0)
	{
		int caps;
		
		if ((caps=ioctl(fd, CDROM_GET_CAPABILITY, 0))>=0)
		{
			fprintf(stderr, "%s is a cdrom\n", path);
			if (caps&CDC_CLOSE_TRAY)
				fprintf(stderr, "CDC_CLOSE_TRAY\n");
			if (caps&CDC_OPEN_TRAY)
				fprintf(stderr, "CDC_OPEN_TRAY\n");
			if (caps&CDC_LOCK)
				fprintf(stderr, "CDC_LOCK\n");
			if (caps&CDC_SELECT_SPEED)
				fprintf(stderr, "CDC_SELECT_SPEED\n");
			if (caps&CDC_SELECT_DISC)
				fprintf(stderr, "CDC_SELECT_DISC\n");
			if (caps&CDC_MULTI_SESSION)
				fprintf(stderr, "CDC_MULTI_SESSION\n");
			if (caps&CDC_MCN)
				fprintf(stderr, "CDC_MCN\n");
			if (caps&CDC_MEDIA_CHANGED)
				fprintf(stderr, "CDC_MEDIA_CHANGED\n");
			if (caps&CDC_PLAY_AUDIO)
				fprintf(stderr, "CDC_PLAY_AUDIO\n");
			if (caps&CDC_RESET)
				fprintf(stderr, "CDC_RESET\n");
			if (caps&CDC_IOCTLS)
				fprintf(stderr, "CDC_IOCTLS\n");
			if (caps&CDC_DRIVE_STATUS)
				fprintf(stderr, "CDC_DRIVE_STATUS\n");
			if (caps&CDC_GENERIC_PACKET)
				fprintf(stderr, "CDC_GENERIC_PACKET\n");
			if (caps&CDC_CD_R)
				fprintf(stderr, "CDC_CD_R\n");
			if (caps&CDC_CD_RW)
				fprintf(stderr, "CDC_CD_RW\n");
			if (caps&CDC_DVD)
				fprintf(stderr, "CDC_DVD\n");
			if (caps&CDC_DVD_R)
				fprintf(stderr, "CDC_DVD_R\n");
			if (caps&CDC_DVD_RAM)
				fprintf(stderr, "CDC_DVD_RAM\n");
			switch (ioctl(fd, CDROM_DISC_STATUS))
			{
				case CDS_NO_INFO: fprintf(stderr, "CDROM doesn't support CDROM_DISC_STATUS\n"); break;
				case CDS_NO_DISC: fprintf(stderr, "No disc\n"); break;
				case CDS_AUDIO: fprintf(stderr, "Audio CD\n"); break;
				case CDS_DATA_1: fprintf(stderr, "Data CD, mode 1, form 1\n"); break;
				case CDS_DATA_2: fprintf(stderr, "Data CD, mode 1, form 2\n"); break;
				case CDS_XA_2_1: fprintf(stderr, "Data CD, mode 2, form 1\n"); break;
				case CDS_XA_2_2: fprintf(stderr, "Data CD, mode 2, form 2\n"); break;
				case CDS_MIXED: fprintf(stderr, "Mixed mode CD\n"); break;
				case -1: perror("ioctl()"); break;
				default:
					 fprintf(stderr, "Unknown cd type\n");
			}
			{
				struct cdrom_mcn mcn;
				if (!ioctl(fd, CDROM_GET_MCN, &mcn))
					fprintf(stderr, "MCN: %13s\n", mcn.medium_catalog_number);
			}
			{
				struct cdrom_tochdr tochdr;
				if (!ioctl(fd, CDROMREADTOCHDR, &tochdr))
				{
					int i;
					struct cdrom_tocentry tocentry;
					fprintf(stderr, "Start track: %d\nStop track: %d\n", tochdr.cdth_trk0, tochdr.cdth_trk1);
					for (i=tochdr.cdth_trk0;i<=(tochdr.cdth_trk1+1);i++)
					{
						if (i>tochdr.cdth_trk1)
							i=CDROM_LEADOUT;
						tocentry.cdte_track=i;
						tocentry.cdte_format=CDROM_MSF; /* CDROM_LBA */
						if (!ioctl(fd, CDROMREADTOCENTRY, &tocentry))
						{
							fprintf(stderr, "cdte_track:    %d%s\n", tocentry.cdte_track, (i==CDROM_LEADOUT)?" LEADOUT":"");
							fprintf(stderr, "cdte_adr:      %d\n", tocentry.cdte_adr);
							fprintf(stderr, "cdte_ctrl:     %d %s\n", tocentry.cdte_ctrl, (tocentry.cdte_ctrl&CDROM_DATA_TRACK)?"(DATA)":"AUDIO");
							fprintf(stderr, "cdte_format:   %d\n", tocentry.cdte_format);
							if (tocentry.cdte_format==CDROM_MSF){
								fprintf(stderr, "cdte_addr.msf.minute: %d\n", tocentry.cdte_addr.msf.minute);
								fprintf(stderr, "cdte_addr.msf.second: %d\n", tocentry.cdte_addr.msf.second);
								fprintf(stderr, "cdte_addr.msf.frame:  %d\n", tocentry.cdte_addr.msf.frame);
							} else {
								fprintf(stderr, "cdte_addr.lba:        %d\n", tocentry.cdte_addr.lba);
							}
							fprintf(stderr, "cdte_datamode: %d\n", tocentry.cdte_datamode);
							fprintf(stderr, "\n");
						}
					}
				}
			}
		}
		close(fd);
	}
}

static void try_i(const char *base, char c)
{
	char dev[32];
	sprintf(dev, "/dev/%s%d", base, c);
	try(dev);
}

static void try_c(const char *base, char c)
{
	char dev[32];
	sprintf(dev, "/dev/%s%c", base, c);
	try(dev);
}


int main(int argc, char *argv[])
{
	char a;
	for (a=0;a<=32;a++)
		try_i("cdroms/cdrom", a);
	for (a=0;a<=32;a++)
		try_i("scd", a);
	for (a='a';a<='z';a++)
		try_c("hd", a);
	
	return 0;
}
