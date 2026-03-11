# 1단계: Flutter 빌드
FROM ghcr.io/cirruslabs/flutter:stable AS build
WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web --release
RUN grep -q "university" build/web/main.dart.js && exit 1 || echo "Clean Build!"

# 👇 [수정] 물리적 파일명 변경 및 참조 수정
WORKDIR /app/build/web
RUN TIMESTAMP=$(date +%s) && \
    # 1. main.dart.js 이름 변경
    mv main.dart.js main.dart.$TIMESTAMP.js && \
    # 2. flutter.js 이름 변경 (이게 핵심)
    mv flutter.js flutter.$TIMESTAMP.js && \
    # 3. flutter.TIMESTAMP.js 내부에서 main.dart.TIMESTAMP.js를 부르도록 수정
    sed -i "s/main.dart.js/main.dart.$TIMESTAMP.js/g" flutter.$TIMESTAMP.js && \
    # 4. index.html에서 flutter.TIMESTAMP.js를 부르도록 수정
    sed -i "s/flutter.js/flutter.$TIMESTAMP.js/g" index.html && \
    # 5. 진입점 파일도 새로 생성
    cp index.html v3.html

# 2단계: Nginx 배포
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]