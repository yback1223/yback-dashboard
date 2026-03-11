# 1단계: Flutter 빌드
FROM ghcr.io/cirruslabs/flutter:stable AS build
WORKDIR /app
COPY . .
RUN flutter pub get

# 👇 [수정] PWA 전략을 none으로 설정하여 서비스 워커 생성을 원천 차단
RUN flutter build web --release --pwa-strategy=none

# 검증 로직 유지
RUN grep -q "university" build/web/main.dart.js && exit 1 || echo "Clean Build!"

# 2단계: 물리적 파일명 변경 및 참조 수정
WORKDIR /app/build/web
RUN TIMESTAMP=$(date +%s) && \
    mv main.dart.js main.dart.$TIMESTAMP.js && \
    mv flutter.js flutter.$TIMESTAMP.js && \
    # 서비스 워커 파일이 혹시 생성되었다면 삭제 (중복 방어)
    rm -f flutter_service_worker.js && \
    sed -i "s/main.dart.js/main.dart.$TIMESTAMP.js/g" flutter.$TIMESTAMP.js && \
    sed -i "s/flutter.js/flutter.$TIMESTAMP.js/g" index.html

# 3단계: Nginx 배포
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]