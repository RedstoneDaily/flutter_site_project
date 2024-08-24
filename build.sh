function get_flutter() {
    sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa
    wget https://storage.flutter-io.cn/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.1-stable.tar.xz
    tar -xf flutter_linux_3.24.1-stable.tar.xz -C /usr/bin/
}

function check_flutter() {
    if ! command -v flutter >/dev/null 2>&1
    then
        echo "flutter not have,auto install"
        get_flutter
    else
        # echo "flutter found"
}

check_flutter

flutter pub get

flutter build web --release --source-maps
