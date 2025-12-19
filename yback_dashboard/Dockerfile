# ------------------------------------------------
# 1단계: Flutter 빌드 (Build Stage)
# ------------------------------------------------
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# 소스 코드 복사
COPY . .

# 의존성 설치 및 웹 빌드
RUN flutter pub get
RUN flutter build web --release

# ------------------------------------------------
# 2단계: Nginx 배포 (Production Stage)
# ------------------------------------------------
FROM nginx:alpine

# 1단계에서 빌드된 결과물(html, js 등)을 Nginx 경로로 복사
COPY --from=build /app/build/web /usr/share/nginx/html

# 우리가 만든 nginx 설정 파일 복사 (아래에서 만들 예정)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 80 포트 오픈
EXPOSE 80

# Nginx 실행
CMD ["nginx", "-g", "daemon off;"]