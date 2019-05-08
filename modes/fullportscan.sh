if [ "$FULLNMAPSCAN" = "0" ]; then
  echo -e "${OKGREEN}====================================================================================${RESET}"
  echo -e "$OKRED SKIPPING FULL NMAP PORT SCAN $RESET"
  echo -e "${OKGREEN}====================================================================================${RESET}"
else
  echo -e "${OKGREEN}====================================================================================${RESET}"
  echo -e "$OKRED PERFORMING TCP PORT SCAN $RESET"
  echo -e "${OKGREEN}====================================================================================${RESET}"
  if [ "$SLACK_NOTIFICATIONS" == "1" ]; then
    /usr/bin/python "$INSTALL_DIR/bin/slack.py" "Running full port scan: $TARGET $MODE `date +"%Y-%m-%d %H:%M"`"
  fi
  nmap -vv -sT -sV -O -A -T4 -oX $LOOT_DIR/nmap/nmap-$TARGET-fullport.xml -p $FULL_PORTSCAN_PORTS $TARGET | tee $LOOT_DIR/nmap/nmap-$TARGET
  cp -f $LOOT_DIR/nmap/nmap-$TARGET-fullport.xml $LOOT_DIR/nmap/nmap-$TARGET.xml 2> /dev/null
  sed -r "s/</\&lh\;/g" $LOOT_DIR/nmap/nmap-$TARGET 2> /dev/null > $LOOT_DIR/nmap/nmap-$TARGET.txt 2> /dev/null
  rm -f $LOOT_DIR/nmap/nmap-$TARGET 2> /dev/null
  xsltproc $INSTALL_DIR/bin/nmap-bootstrap.xsl $LOOT_DIR/nmap/nmap-$TARGET.xml -o $LOOT_DIR/nmap/nmapreport-$TARGET.html 2> /dev/null
  echo -e "${OKGREEN}====================================================================================${RESET}"
  echo -e "$OKRED PERFORMING UDP PORT SCAN $RESET"
  echo -e "${OKGREEN}====================================================================================${RESET}"
  nmap -Pn -sU -sV -A -T4 -v -p $DEFAULT_UDP_PORTS -oX $LOOT_DIR/nmap/nmap-$TARGET-fullport-udp.xml $TARGET | tee $LOOT_DIR/nmap/nmap-$TARGET-udp
  sed -r "s/</\&lh\;/g" $LOOT_DIR/nmap/nmap-$TARGET-udp 2> /dev/null > $LOOT_DIR/nmap/nmap-$TARGET-udp.txt 2> /dev/null
  rm -f $LOOT_DIR/nmap/nmap-$TARGET 2> /dev/null
  if [ "$SLACK_NOTIFICATIONS" == "1" ]; then
    /usr/bin/python "$INSTALL_DIR/bin/slack.py" "Finished brute force: $TARGET $MODE `date +"%Y-%m-%d %H:%M"`"
  fi
fi