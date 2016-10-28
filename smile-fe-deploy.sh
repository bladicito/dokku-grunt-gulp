#!/usr/bin/env bash
echo "-----> Smilemary frontendFiles will be build now..."
echo "-----> Node Modules will be installed and afterwared grunt will be run"

COMMAND=$(cat <<EOF
cd "/app" &&
new_path="\$(find / -name npm | tail -1 | xargs -I % sh -c "dirname %")" &&
PATH="\$PATH:\$new_path" &&
PATH="\$PATH:\$(npm bin)" &&
npm install
npm install grunt-cli &&
grunt
EOF
)

id=$(docker run -d $IMAGE /bin/bash -c "$COMMAND")
docker attach $id
test $(docker wait $id) -eq 0
docker commit $id $IMAGE > /dev/null
echo "-----> Smilemary frontendFiles were compiled"