echo "wireguird: cleaning..."

deb_file="./build/wireguird_amd64.deb"
if [ -e "$deb_file" ]; then
  rm -r "$deb_file"
fi

usr_w_dir="./deb/usr/"
if [ -e "$usr_w_dir" ]; then
  rm -r "$usr_w_dir"
fi

mkdir -p "$usr_w_dir"/bin
mkdir -p "$usr_w_dir"/share/wireguird

echo "wireguird: building go binary..."
time {
  go generate
  go build -ldflags "-s -w" -trimpath -o "$usr_w_dir"/bin/wireguird
}

echo "wireguird: copying icons..."
cp -r ./Icon/ "$usr_w_dir"/share/wireguird

echo "wireguird: building deb package..."

if [ ! -d "./build/" ]; then
  mkdir ./build/
fi

dpkg-deb --root-owner-group --build ./deb $deb_file
echo "wireguird: done"
