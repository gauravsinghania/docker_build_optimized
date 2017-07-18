FROM openjdk:8-jdk-alpine
# ----
# Install Maven
RUN apk add --no-cache curl tar bash
ARG MAVEN_VERSION=3.3.9
ARG USER_HOME_DIR="/root"
RUN mkdir -p /usr/share/maven && \
curl -fsSL http://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -xzC /usr/share/maven --strip-components=1 && \
ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
# speed up Maven JVM a bit
ENV MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"
ENTRYPOINT ["/usr/bin/mvn"]
# ----
# Install project dependencies and keep sources
# make source folder
RUN mkdir -p /usr/app
RUN mkdir -p /usr/app/child
WORKDIR /usr/app

# install maven dependency packages (keep in image)
COPY pom.xml /usr/app
COPY child1/pom.xml /usr/app/child1/pom.xml
COPY child2/pom.xml /usr/app/child2/pom.xml
# copy other source files (keep in image)

RUN mvn -T 1C install
RUN rm -rf child1/target child2/target

COPY child1 /usr/app/child1
COPY child2 /usr/app/child2