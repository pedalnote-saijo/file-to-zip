#!/bin/sh

# create_at 2020/05/12

# usage
# {}内のファイルはterminalへドラックアンドドロップで良い
# $ sh {file_to_zip.sh} {zipにしたいファイルorディレクトリ}
# 圧縮後PWが表示されるので必ず保管すること

file=$1
echo $file
zip='.zip'
ext=$(echo ${file##*.})

pw=$(cat /dev/urandom | \
LC_CTYPE=alpha tr -dc '1-9a-zA-Z' | fold -w 12 | \
grep -E '[1-9]'| grep -E '[a-z]' | grep -E '[A-Z]' | \
head -n 1)

if [ $ext = $file ]; then
    echo "dir"
    cd $(echo $(dirname ${file}))

    expect -c "
    set timeout 5
    spawn zip -e -r $file$zip ${file##*/}
    expect \"Enter password:\"
    send \"$pw\n\"
    expect \"Verify password:\"
    send \"$pw\n\"
    interact
    "
else
    echo "file"
    cd $(echo $(dirname ${file}))
    expect -c "
    set timeout 5
    spawn zip -e $file$zip ${file##*/}
    expect \"Enter password:\"
    send \"$pw\n\"
    expect \"Verify password:\"
    send \"$pw\n\"
    interact
    "
fi
echo PW: $pw
