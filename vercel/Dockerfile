FROM whoicd/icd-api:latest

# acceptLicense=true means you accept the WHO ICD-API license: https://icd.who.int/docs/icd-api/license/
ENV acceptLicense=true \
    saveAnalytics=false \
    include=2026-01_en \
    TMPDIR=/usr/share/icdapi/icddata

COPY --chmod=755 preload.sh start.sh /usr/share/icdapi/
RUN sed -i 's/\r$//' /usr/share/icdapi/preload.sh /usr/share/icdapi/start.sh \
 && /usr/share/icdapi/preload.sh

EXPOSE 80
ENTRYPOINT ["/usr/share/icdapi/start.sh"]
