# Use an official Perl runtime as parent image
FROM perl:latest
MAINTAINER John Eastan john.eastman@gmail.com

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive LANG=en_US.UTF-8 LC_ALL=C.UTF-8 LANGUAGE=en_US.UTF-8

RUN apt-get -q update
RUN apt-get -qy upgrade
RUN apt-get install -qy build-essential

# install package requirements for po4a
RUN apt-get install -qy gettext liblocale-gettext-perl xsltproc

# install the pre-requisites for po4a
RUN cpan -T install Module::Build
RUN cpan -T install Locale::gettext
RUN cpan -T install Unicode::GCString
RUN cpan -T install Text::WrapI18N
RUN cpan -T install Term::ReadKey

# cachebuster value is the latest commit to github for po4a
# you can update this to force a rebuild of the image
RUN cachebuster=15d5f3f git clone https://github.com/mquinson/po4a.git

# build po4a
RUN cd po4a && perl Build.PL
RUN cd po4a && ./Build; exit 0
RUN cd po4a && ./Build install

# Set the working directory
WORKDIR /src

# copy the run script
COPY [ "./run_po4a.sh", "/app/run_po4a.sh" ]
RUN [ "chmod", "+x",  "/app/run_po4a.sh" ]

ENTRYPOINT [ "/app/run_po4a.sh" ]
