ARG F2BIMG=fail2ban-ng

FROM ${F2BIMG}
RUN python -m pip install --no-cache-dir ptvsd==3.0.0
EXPOSE 3000