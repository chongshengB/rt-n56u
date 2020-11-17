
all:

clean:

romfs:
	$(ROMFSINST) /usr/bin/kms.sh
	$(ROMFSINST) /etc_ro/vlmcsd.kmd
	$(ROMFSINST) /www/Advanced_kms.asp
	tar -xzf ./vlmcsd.tar.gz -C $(INSTALLDIR)/usr/bin
	chmod 777 $(INSTALLDIR)/usr/bin/vlmcsd
