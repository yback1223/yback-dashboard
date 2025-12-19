# 1. Build Stage (Gradle 빌드)
FROM gradle:jdk17 AS builder
WORKDIR /app
COPY . .
# 테스트 제외하고 빌드 (메모리 절약)
RUN ./gradlew clean build -x test

# 2. Run Stage (실행)
FROM amazoncorretto:17
WORKDIR /app
# 위 builder 단계에서 만들어진 JAR 파일만 쏙 가져옴
COPY --from=builder /app/build/libs/*-SNAPSHOT.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]