FROM python:3.9 as base

ENV DEBIAN_FRONTEND noninteractive

# Setup env
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONFAULTHANDLER 1

FROM base AS python-deps

RUN apt-get update
RUN apt-get install -y libssl-dev
RUN apt-get install -y build-essential
RUN apt-get install -y libpcre3-dev
RUN apt-get install -y libpq-dev
#install the latest python
# Install pipenv and compilation dependencies
RUN pip install pipenv
RUN apt-get update && apt-get install -y --no-install-recommends gcc
#make sure that we can run pipenv
RUN pipenv --version
# Clean up
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

FROM python-deps AS build

# Install project dependencies and build
RUN mkdir /app
WORKDIR /app
COPY Pipfile Pipfile.lock /app/
RUN cd /app/ && PIPENV_VENV_IN_PROJECT=1 pipenv install --deploy

FROM build AS runtime

#COPY --from=python-deps /app/.venv /app/.venv

ENV PATH="/app/.venv/bin:$PATH"

COPY . /app

EXPOSE 8000
ENV PORT=8000

CMD ["/app/start.sh"]
