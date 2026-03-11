# 1단계: Flutter 빌드
FROM ghcr.io/cirruslabs/flutter:stable AS build
WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web --release
RUN grep -q "university" build/web/main.dart.js && exit 1 || echo "Clean Build!"

# 👇 [수정] 물리적 파일명 변경 및 참조 수정
WORKDIR /app/build/web
WORKDIR /app/build/web
RUN TIMESTAMP=$(date +%s) && \
    mv main.dart.js main.dart.$TIMESTAMP.js && \
    mv flutter.js flutter.$TIMESTAMP.js && \
    sed -i "s/main.dart.js/main.dart.$TIMESTAMP.js/g" flutter.$TIMESTAMP.js && \
    sed -i "s/flutter.js/flutter.$TIMESTAMP.js/g" index.html

# 2단계: Nginx 배포
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]