function get_flutter() {
    wget https://storage.flutter-io.cn/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.1-stable.tar.xz -O flutter.tar.xz
    tar -xf flutter.tar.xz -C ./
    rm flutter.tar.xz
    export PATH=$(pwd)/flutter/bin:$PATH
}

function check_flutter() {
    if ! command -v flutter >/dev/null 2>&1
    then
        echo "flutter not have,auto install"
        get_flutter
    else
        echo "flutter found"
    fi
}

check_flutter

flutter pub get

flutter build web --release --source-maps
