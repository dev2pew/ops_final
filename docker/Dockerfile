# --- Stage 1: Build ---
FROM gradle:8.5-jdk17-alpine AS builder
WORKDIR /build

# Copy Gradle config first to cache dependencies
COPY app/build.gradle app/settings.gradle ./
COPY app/gradle ./gradle
# Note: In a real scenario, you should commit the gradlew script.
# If it's missing, we can use the 'gradle' command from the base image.
# However, to satisfy the requirement "Use Gradle Wrapper", we assume it exists.
COPY app/gradlew .

# Download dependencies (fail safe if wrapper missing, use gradle)
RUN if [ -f "./gradlew" ]; then ./gradlew build --no-daemon || return 0; else gradle build --no-daemon || return 0; fi

# Copy source code
COPY app/src ./src

# Build the application
RUN if [ -f "./gradlew" ]; then \
      ./gradlew clean bootJar -x test --no-daemon; \
    else \
      gradle clean bootJar -x test --no-daemon; \
    fi

# --- Stage 2: Runtime ---
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Create a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Install curl for healthcheck
RUN apk add --no-cache curl

# Copy JAR from builder
COPY --from=builder /build/build/libs/*.jar app.jar

# Set ownership
RUN chown appuser:appgroup app.jar

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 8080

# Healthcheck using Actuator
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]
