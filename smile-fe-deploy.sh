#!/bin/bash

echo "-----> Smilemary frontendFiles will be build now..."
echo "-----> Node Modules will be installed and afterwars grunt will be run"

APP="$1"; IMAGE="dokku/$APP"
COMMAND=$(cat <<EOF
apt-get update -y &&
apt-get install -y node npm &&
cd "/app" &&
new_path="\$(find / -name npm | tail -1 | xargs -I % sh -c "dirname %")" &&
PATH="\$PATH:\$new_path" &&
PATH="\$PATH:\$(npm bin)" &&
npm install &&
npm install -g grunt-cli &&
rm /usr/sbin/node &&
ln -s /usr/bin/nodejs /usr/sbin/node &&
echo "start grunt" &&
grunt --verbose &&
echo "end grunt"
EOF
)

id=$(docker run -d $IMAGE /bin/bash -c "$COMMAND")
docker attach $id
test $(docker wait $id) -eq 0
docker commit $id $IMAGE > /dev/null
echo "-----> Smilemary frontendFiles were compiled"