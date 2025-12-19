# 1 - BUILD
FROM gradle:8.5-jdk17-alpine AS builder
WORKDIR /build

# GRADLE
COPY app/build.gradle app/settings.gradle ./
COPY app/gradle ./gradle

# note: in a real scenario, you should commit the gradlew script.
# if it's missing, we can use the 'gradle' command from the base image.
# however, to satisfy the requirement "use gradle wrapper", we assume it exists.
COPY app/gradlew .

# DEPS
RUN if [ -f "./gradlew" ]; then ./gradlew build --no-daemon || return 0; else gradle build --no-daemon || return 0; fi

# SOURCE
COPY app/src ./src

# BUILD
RUN if [ -f "./gradlew" ]; then \
      ./gradlew clean bootJar -x test --no-daemon; \
    else \
      gradle clean bootJar -x test --no-daemon; \
    fi

# RUNTIME
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# CREATE USER
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# HEALTHCHECK
RUN apk add --no-cache curl

# COPY JAR
COPY --from=builder /build/build/libs/*.jar app.jar

# PERMS
RUN chown appuser:appgroup app.jar

# SWITCH TO USER
USER appuser

# NETWORK
EXPOSE 8080

# ACTUATOR HEALTHCHECK
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]
