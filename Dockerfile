FROM python:3.7.2-alpine

# install commands are copied from ethereum/solc Dockerfile with minor modification 
# original lines that were modified are commented + each line is RUNed separately
RUN apk --no-cache --update add build-base cmake boost-dev git
RUN sed -i -E -e 's/include <sys\/poll.h>/include <poll.h>/' /usr/include/boost/asio/detail/socket_types.hpp
RUN git clone --depth 1 --recursive -b release https://github.com/ethereum/solidity
RUN cd /solidity && cmake -DCMAKE_BUILD_TYPE=Release -DTESTS=0 -DSTATIC_LINKING=1
RUN cd /solidity && make solc && install -s solc/solc /usr/bin
RUN cd / && rm -rf solidity
#RUN apk --no-cache del sed build-base git make cmake gcc g++ musl-dev curl-dev boost-dev
RUN rm -rf /var/cache/apk/*

WORKDIR /workdir
COPY . .

ENTRYPOINT ["python3", "/workdir/Solstice.py"]
