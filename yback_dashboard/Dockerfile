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
    # 1. 메인 로직 파일명 변경
    mv main.dart.js main.dart.$TIMESTAMP.js && \
    # 2. 엔진 로더 파일명 변경
    mv flutter.js flutter.$TIMESTAMP.js && \
    # 3. 로더가 새 로직을 부르도록 수정
    sed -i "s/main.dart.js/main.dart.$TIMESTAMP.js/g" flutter.$TIMESTAMP.js && \
    # 4. index.html이 새 로더를 부르도록 수정
    sed -i "s/flutter.js/flutter.$TIMESTAMP.js/g" index.html && \
    # 5. [핵심] index.html을 my_index.html로 복사
    cp index.html my_index.html

# 2단계: Nginx 배포
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]