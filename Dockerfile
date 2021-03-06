FROM zenhack/sandstorm-http-bridge:276 as bridge

FROM bridge as dotnet-run
RUN apk update
RUN apk add \
    icu-libs \
    krb5-libs \
    libgcc \
    libintl \
    libssl1.1 \
    libstdc++ \
    zlib

FROM dotnet-run as dotnet-build
RUN wget https://download.visualstudio.microsoft.com/download/pr/1e5f22cc-4ac9-4316-8fbc-5ff884140d02/6f8c3a67deb898fb7e6b3ac09dcff2b3/dotnet-sdk-5.0.100-preview.8.20417.9-linux-musl-x64.tar.gz -O dotnet.tar.gz
RUN mkdir -p /opt/dotnet
RUN tar -C /opt/dotnet -xvf dotnet.tar.gz
RUN rm dotnet.tar.gz
COPY ./build.sh ./
RUN ./build.sh

FROM dotnet-run
COPY --from=bridge sandstorm-http-bridge /
COPY --from=dotnet-build /opt/app/publish /opt/app/publish
COPY ./launcher.sh /opt/app/launcher.sh
RUN apk add strace
