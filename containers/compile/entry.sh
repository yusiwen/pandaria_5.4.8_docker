#!/usr/bin/env bash

escape() {
   local tmp
   tmp=$(echo $1 | sed 's/[^a-zA-Z0-9\s:]/\\\&/g')
   echo "$tmp"
}

if [ ! -d "$SOURCE_PREFIX" ]; then
   git clone --depth 1 --branch master "$GIT_URL_SOURCE" "$SOURCE_PREFIX"
   git config pull.rebase true
else
   cd "$SOURCE_PREFIX" || return
   git pull origin master
fi

if [ ! -d "$INSTALL_PREFIX/logs" ]; then
   mkdir -p "$INSTALL_PREFIX"/logs
fi

if [ ! -d "$INSTALL_PREFIX/etc" ]; then
   mkdir -p "$INSTALL_PREFIX"/etc
fi

if [ ! -d "$SOURCE_PREFIX/build" ]; then
   mkdir -p "$SOURCE_PREFIX"/build
fi

cd "$SOURCE_PREFIX"/build || return

cmake .. -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" -DCMAKE_C_COMPILER="$CMAKE_C_COMPILER" -DCMAKE_CXX_COMPILER="$CMAKE_CXX_COMPILER" -DSCRIPTS="$SCRIPTS" -DWITH_WARNINGS="$WARNINGS" -DTOOLS="$EXTRACTORS" -DCMAKE_CXX_FLAGS="$CMAKE_CXX_FLAGS"

make -j "$(nproc)"

if [ "$MAKE_INSTALL" -eq 1 ]; then
   echo "Make install"
   make install

   if [ ! -f "$CONFIG_PATH/authserver.conf" ]; then
      echo "updating authserver.conf files"
      cp "$CONFIG_PATH"/authserver.conf.dist "$CONFIG_PATH"/authserver.conf

      sed -i -e "/LogsDir =/ s/= .*/= $(escape $LOGS_DIR_PATH)/" "$CONFIG_PATH"/authserver.conf
      sed -i -e "/LoginDatabaseInfo =/ s/= .*/= \"$(escape $DB_CONTAINER)\;3306\;$(escape $SERVER_DB_USER)\;$(escape $SERVER_DB_PWD)\;auth\"/" "$CONFIG_PATH"/authserver.conf
   fi

   if [ ! -f "$CONFIG_PATH/worldserver.conf" ]; then
      echo "updating worldserver.conf files"
      cp "$CONFIG_PATH"/worldserver.conf.dist "$CONFIG_PATH"/worldserver.conf

      sed -i -e "/DataDir =/ s/= .*/= $(escape $DATA_DIR_PATH)/" $CONFIG_PATH/worldserver.conf
      sed -i -e "/LogsDir =/ s/= .*/= $(escape $LOGS_DIR_PATH)/" $CONFIG_PATH/worldserver.conf

      sed -i -e "/LoginDatabaseInfo     =/ s/= .*/= \"$(escape $DB_CONTAINER)\;3306\;$(escape $SERVER_DB_USER)\;$(escape $SERVER_DB_PWD)\;auth\"/" "$CONFIG_PATH"/worldserver.conf
      sed -i -e "/WorldDatabaseInfo     =/ s/= .*/= \"$(escape $DB_CONTAINER)\;3306\;$(escape $SERVER_DB_USER)\;$(escape $SERVER_DB_PWD)\;world\"/" "$CONFIG_PATH"/worldserver.conf
      sed -i -e "/CharacterDatabaseInfo =/ s/= .*/= \"$(escape $DB_CONTAINER)\;3306\;$(escape $SERVER_DB_USER)\;$(escape $SERVER_DB_PWD)\;characters\"/" "$CONFIG_PATH"/worldserver.conf
      sed -i -e "/ArchiveDatabaseInfo   =/ s/= .*/= \"$(escape $DB_CONTAINER)\;3306\;$(escape $SERVER_DB_USER)\;$(escape $SERVER_DB_PWD)\;archive\"/" "$CONFIG_PATH"/worldserver.conf
      sed -i -e "/FusionCMSDatabaseInfo =/ s/= .*/= \"$(escape $DB_CONTAINER)\;3306\;$(escape $SERVER_DB_USER)\;$(escape $SERVER_DB_PWD)\;fusion\"/" "$CONFIG_PATH"/worldserver.conf

      sed -i -e "/GameType =/ s/= .*/= $(escape $GAME_TYPE)/" "$CONFIG_PATH"/worldserver.conf
      sed -i -e "/RealmZone =/ s/= .*/= $(escape $REALM_ZONE)/" "$CONFIG_PATH"/worldserver.conf
      sed -i -e "/Motd =/ s/= .*/= \"$(escape $MOTD_MSG)\"/" "$CONFIG_PATH"/worldserver.conf

      sed -i -e "/Ra.Enable =/ s/= .*/= $(escape $RA_ENABLE)/" "$CONFIG_PATH"/worldserver.conf

      sed -i -e "/SOAP.Enabled =/ s/= .*/= $(escape $SOAP_ENABLE)/" "$CONFIG_PATH"/worldserver.conf
      sed -i -e "/SOAP.IP =/ s/= .*/= $(escape $SOAP_IP)/" "$CONFIG_PATH"/worldserver.conf
   fi
fi

if [ "$MAKE_INSTALL" -eq 0 ]; then
   echo "Open shell"
   /bin/bash
fi
