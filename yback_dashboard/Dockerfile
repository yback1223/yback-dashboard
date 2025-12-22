# ------------------------------------------------
# 1단계: Flutter 빌드 (Build Stage)
# ------------------------------------------------
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app
COPY . .

RUN flutter pub get
RUN flutter build web --release

# 👇 [추가] 캐시 버스팅 자동화 (sed 명령어로 파일 내용 치환)
# 1. index.html 안의 flutter.js 뒤에 ?v=타임스탬프 추가
RUN sed -i "s/flutter.js/flutter.js?v=$(date +%s)/g" build/web/index.html

# 2. flutter.js 안의 main.dart.js 뒤에 ?v=타임스탬프 추가
RUN sed -i "s/main.dart.js/main.dart.js?v=$(date +%s)/g" build/web/flutter.js

# ------------------------------------------------
# 2단계: Nginx 배포
# ------------------------------------------------
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]