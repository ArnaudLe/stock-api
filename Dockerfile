# Stage 1: Build stage using Gradle
FROM gradle:8.11.1-jdk23 AS build
WORKDIR /app
COPY build.gradle settings.gradle ./
COPY gradle gradle
COPY gradlew gradlew
COPY src src

# Set execution permission for the Gradle wrapper
RUN chmod +x ./gradlew
RUN ./gradlew clean build -x test  # Build the project, skip tests

# Stage 2: Final image using OpenJDK 23
FROM openjdk:23-jdk
VOLUME /tmp

# Copy the JAR from the build stage
COPY --from=build /app/build/libs/*.jar app.jar

# Set the entrypoint to run the JAR file
ENTRYPOINT ["java", "-jar", "/app.jar"]

# Expose the port your Spring Boot app runs on
EXPOSE 8080