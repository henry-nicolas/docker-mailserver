FROM debian:buster-slim

ARG VMAIL_UID=1024
ARG VMAIL_GID=1024
ARG DEBIAN_FRONTEND=noninteractive

# Configuration environment
ENV POSTFIX_MYNETWORKS= \
    POSTFIX_FQDN= \
    POSTFIX_RELAYHOST= \
    POSTFIX_LDAP_DOMAIN_FILTER= \
    POSTFIX_LDAP_MAILBOX_FILTER= \
    POSTFIX_LDAP_ALIAS_FILTER= \
    POSTFIX_LDAP_SENDER_FILTER= \
    POSTFIX_LDAP_GROUP_FILTER= \
    DOVECOT_LDAP_USER_ATTR= \
    DOVECOT_LDAP_USER_FILTER= \
    DOVECOT_LDAP_PASS_ATTR= \
    DOVECOT_LDAP_PASS_FILTER= \
    DOVECOT_MAILBOX_SIZE="2GB" \
    RSPAMD_REDIS_HOST= \
    RSPAMD_REDIS_DBNUM= \
    FAIL2BAN_IGNORE_IP= \
    ALL_DOMAIN= \
    ALL_POSTMASTER= \
    ALL_TLS_CERT= \
    ALL_TLS_CERT_KEY= \
    ALL_LDAP_HOST= \
    ALL_LDAP_BIND_DN= \
    ALL_LDAP_BIND_PW= \
    ALL_LDAP_SEARCH_BASE= \
    ALL_LDAP_TLS_REQUIRED="yes" \
    ALL_HTTP_PROXY_HOST= \
    ALL_HTTP_PROXY_PORT=

RUN addgroup --gid $VMAIL_UID vmail \
    && adduser --disabled-password --uid $VMAIL_UID --gid $VMAIL_GID vmail \
    && apt-get update \
    && apt-get -qy --no-install-recommends install postfix postfix-ldap postfix-pcre dovecot-core dovecot-ldap dovecot-imapd dovecot-lmtpd dovecot-sieve dovecot-managesieved \ 
       rspamd clamav-daemon fail2ban supervisor python3-pip python3-setuptools iptables \
    && pip3 install --no-input j2cli \
    && rm -fr /etc/dovecot/ /etc/supervisor/ /etc/fail2ban/jail.d/defaults-debian.conf

COPY rootfs /
RUN  chmod +x /usr/local/bin/* /etc/dovecot/sieve/*
ENTRYPOINT ["docker-entrypoint"]

VOLUME /var/log
VOLUME /var/mail/vhosts
VOLUME /var/spool/postfix

EXPOSE 25 465 587 993 4190
CMD ["supervisord", "-c", "/etc/supervisord.conf"]
