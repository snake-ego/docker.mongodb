FROM alpine:edge

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
ADD http://af.it-test.pw/su-exec/alpine/suexec /usr/local/bin/suexec

RUN set -x \
    && apk --update --no-cache add \
    mongodb \
    mongodb-tools \
    && chmod +x /docker-entrypoint.sh /usr/local/bin/suexec \
    && rm -rf /var/lib/mongodb

VOLUME ["/data/db", "/data/configdb"]
EXPOSE 27017

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD [""]
