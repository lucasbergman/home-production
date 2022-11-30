all: sasl_passwd.db valias.db vmailbox.db

sasl_passwd.db: sasl_passwd
	/usr/sbin/postmap hash:sasl_passwd

valias.db: valias
	/usr/sbin/postmap hash:valias

vmailbox.db: vmailbox
	/usr/sbin/postmap hash:vmailbox
