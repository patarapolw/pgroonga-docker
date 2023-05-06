# Based on debian-slim
FROM postgres:12

RUN mkdir -p /app
RUN apt-get update

# pgroonga extension
# Does not officially support alpine
RUN apt-get install -y curl
RUN curl -O https://packages.groonga.org/debian/groonga-apt-source-latest-bullseye.deb
RUN apt-get install -y ./groonga-apt-source-latest-bullseye.deb
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list
RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update
RUN apt-get install -y postgresql-12-pgdg-pgroonga
RUN apt-get install -y groonga-tokenizer-mecab
RUN apt-get install -y groonga-token-filter-stem

# postgres-json-schema extension
WORKDIR /app
RUN apt-get install -y git make
RUN git clone --depth 1 https://github.com/gavinwahl/postgres-json-schema.git
RUN cd postgres-json-schema && make install

# pg_jieba extension
WORKDIR /app
RUN apt-get install -y cmake build-essential postgresql-server-dev-12
RUN git clone --depth 1 https://github.com/jaiminpan/pg_jieba.git
WORKDIR /app/pg_jieba
RUN git submodule update --init --recursive
RUN mkdir build && cd build && cmake -DPostgreSQL_TYPE_INCLUDE_DIR=/usr/include/postgresql/12/server .. && make && make install
