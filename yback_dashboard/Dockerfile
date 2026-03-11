# 1단계: Flutter 빌드
FROM ghcr.io/cirruslabs/flutter:stable AS build
WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web --release

# 👇 [수정] 물리적 파일명 변경 및 참조 수정
WORKDIR /app/build/web
RUN TIMESTAMP=$(date +%s) && \
    # 1. main.dart.js를 물리적으로 복사/변경 (예: main.1710115200.js)
    mv main.dart.js main.dart.$TIMESTAMP.js && \
    # 2. flutter.js에서 바뀐 파일명을 호출하도록 수정
    sed -i "s/main.dart.js/main.dart.$TIMESTAMP.js/g" flutter.js && \
    # 3. index.html에서 flutter.js 호출 시 캐시 방지 (쿼리 스트링)
    sed -i "s/flutter.js/flutter.js?v=$TIMESTAMP/g" index.html && \
    # 4. Service Worker 완전 박멸 (네 로직 유지)
    sed -i 's/serviceWorker/no-serviceWorker/g' index.html && \
    sed -i 's/flutter_service_worker.js//g' index.html && \
    # 5. favicon 등 기타 리소스 캐시 방지
    sed -i "s/favicon.png/favicon.png?v=$TIMESTAMP/g" index.html

# 2단계: Nginx 배포
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]