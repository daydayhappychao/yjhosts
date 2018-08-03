#! sudo /bin/bash


STARTLINE="你说你要干点啥："
STARTMENU=(
  "更换hosts"
  "查看所有hosts"
  "查看当前hosts"
)
STARTCHECKED=0
STARTCOLOR="\\033[33m"
CHECKED="\\033[32m→ "
NOCHECKED="\\033[0m  "
CLEAR="\\033[0m"
CURRENTCHECKED="0"
FILEARR=()
CURRENTFILE=0
CURRENTHOSTSCONTENT=""
ROOT="/usr/local/yjhosts"
KEY=()

GETSTEP1()
{
  echo ""
  if [ "$CURRENTHOSTSCONTENT"x != x ];then
    echo -e "$CURRENTHOSTSCONTENT\n"
  fi
  echo -e "$STARTCOLOR$STARTLINE$CLEAR"
  for MENU in ${STARTMENU[@]};
  do
    if [ "$MENU"x = "${STARTMENU[$STARTCHECKED]}"x ]; then
      echo -e "$CHECKED$MENU$CLEAR"
    else
      echo -e "$NOCHECKED$MENU$CLEAR"
    fi
  done
}

GETHOSTSFILES()
{
  FILES=`ls $ROOT\/hosts | grep -v "^\."`
  FILEARR=($FILES)
}

SHOWHOSTSFILES()
{
  clear
  echo -e "\n$STARTCOLOR$1$CLEAR"
  for FILE in ${FILEARR[@]};
  do
    if [ "$FILE"x = "${FILEARR[$CURRENTFILE]}"x ]; then
      echo -e  "$CHECKED$FILE$CLEAR"
    else
      echo -e  "$NOCHECKED$FILE$CLEAR"
    fi  
  done
}

CHANGEHOSTS()
{
  SHOWHOSTSFILES "请选择你要更换的hosts文件" 
  while :
  do
    read -s -n 1 KEY
    case ${KEY[0]} in
      "B" | "j")
        if [ $((${#FILEARR[@]}-1)) -gt $CURRENTFILE ];then
          ((CURRENTFILE++))
          SHOWHOSTSFILES "请选择你要更换的hosts文件" 
        fi
        ;;
      "A" | "k")
        if [ 0 -lt $CURRENTFILE ];then
          ((CURRENTFILE--))
          SHOWHOSTSFILES "请选择你要更换的hosts文件" 
        fi
        ;;
      "" | "o")
        rm $ROOT/hosts.bak*
        #mv /etc/hosts $ROOT/hosts.bak${FILEARR[$CURRENTFILE]}
        touch $ROOT/hosts.bak${FILEARR[$CURRENTFILE]}
        cp $ROOT/hosts/${FILEARR[$CURRENTFILE]} /etc/hosts
        echo -e "\n恭喜,hosts文件成功替换成${FILEARR[$CURRENTFILE]}\n"
        break
        ;;
      *)
        continue
        ;;
    esac
  done
}

VIEWHOSTS()
{
  SHOWHOSTSFILES "请选择你要操作的hosts文件(v/o/enter:查看; d:删除; c:新增)" 
  while :
  do
    read -s -n 1 KEY
    case ${KEY[0]} in
      "B" | "j")
        if [ $((${#FILEARR[@]}-1)) -gt $CURRENTFILE ];then
          ((CURRENTFILE++))
          SHOWHOSTSFILES "请选择你要操作的hosts文件(v/o/enter:查看; d:删除; c:新增)" 
        fi
        ;;
      "A" | "k")
        if [ 0 -lt $CURRENTFILE ];then
          ((CURRENTFILE--))
          SHOWHOSTSFILES "请选择你要操作的hosts文件(v/o/enter:查看; d:删除; c:新增)" 
        fi
        ;;
      "" | "o" | "v")
        vim "$ROOT/hosts/${FILEARR[$CURRENTFILE]}"
        SHOWHOSTSFILES "请选择你要操作的hosts文件(v/o/enter:查看; d:删除; c:新增)" 
        ;;
      "d")
        rm "$ROOT/hosts/${FILEARR[$CURRENTFILE]}"
        GETHOSTSFILES
        CURRENTFILE=0
        SHOWHOSTSFILES "请选择你要操作的hosts文件(v/o/enter:查看; d:删除; c:新增)" 
        ;;
      "c")
        ADDHOSTS
        ;;
      *)
        continue
        ;;
    esac
  done
}

ADDHOSTS()
{
  clear
  read -ep  '请输入新的hosts的名称: ' RES
  if [ "$RES"x != x ];then
    cp $ROOT/hosts/.base $ROOT/hosts/$RES
    vim $ROOT/hosts/$RES
    GETHOSTSFILES
    VIEWHOSTS
  else
    ADDHOSTS
  fi
}

START()
{
  GETSTEP1 "0"
  while :
  do
    read -s -n 1 KEY
    case ${KEY[0]} in
      "B" | "j")
        if [ $((${#STARTMENU[@]}-1)) -gt $STARTCHECKED ]; then
          clear
          ((STARTCHECKED++))
          GETSTEP1
        fi
        ;;
      "A" | "k")
        if [ 0 -lt $STARTCHECKED ]; then
          clear
          ((STARTCHECKED--))
          GETSTEP1
        fi
        ;;
      "" | "o")
        GETHOSTSFILES
        case $STARTCHECKED in
          "0") CHANGEHOSTS ;;
          "1") VIEWHOSTS ;;
          "2") 
          clear
          CURRENTHOSTSCONTENT="$STARTCOLOR""当前hosts: "`ls $ROOT | grep hosts.bak`"\n$CLEAR"`cat /etc/hosts`
          CURRENTHOSTSCONTENT=${CURRENTHOSTSCONTENT/"hosts.bak"/""}
          START
          ;;
        esac
        break
        ;;
      *)
        continue
        ;;
    esac
  done
}


clear
START


