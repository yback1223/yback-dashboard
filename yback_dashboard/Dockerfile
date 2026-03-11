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
# 이거였다 시발
WORKDIR /app/build/web
RUN TIMESTAMP=$(date +%s) && \
    # 1. 파일명에 타임스탬프 삽입 (물리적 변경)
    mv main.dart.js main.dart.$TIMESTAMP.js && \
    mv flutter.js flutter.$TIMESTAMP.js && \
    mv flutter_bootstrap.js flutter_bootstrap.$TIMESTAMP.js && \
    # 2. index.html에서 참조 경로 수정
    sed -i "s/flutter_bootstrap.js/flutter_bootstrap.$TIMESTAMP.js/g" index.html && \
    # 3. flutter_bootstrap.js 내부에서 호출하는 파일명 수정
    sed -i "s/main.dart.js/main.dart.$TIMESTAMP.js/g" flutter_bootstrap.$TIMESTAMP.js && \
    sed -i "s/flutter.js/flutter.$TIMESTAMP.js/g" flutter_bootstrap.$TIMESTAMP.js && \
    # 4. (혹시 모르니) PWA 매니페스트 삭제
    rm -f flutter_service_worker.js manifest.json

# 3단계: Nginx 배포
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]