#!/bin/bash

# PiStation Menu by Renetrox
# Instalador y gestor de temas estilo PS4 para EmulationStation

MENU_DIR="$HOME/RetroPie/retropiemenu"
ICON_DIR="$MENU_DIR/icons"

# NOMBRES REALES
MENU_FILE="PiStation_menu.sh"
ICON_FILE="store.png"

GAMELIST="$HOME/.emulationstation/gamelists/retropie/gamelist.xml"

# Tema fuente
PISTATION_THEME="$HOME/.emulationstation/themes/Pi-Station-X"

TEMAS=(
  "https://github.com/Renetrox/Pi-Station-X $PISTATION_THEME"
  "https://github.com/Renetrox/Mk1 $HOME/.emulationstation/themes/Mk1"
  "https://github.com/Renetrox/Pi-Station-Batman $HOME/.emulationstation/themes/Pi-Station-Batman"
  "https://github.com/Renetrox/PiStation-Medievil $HOME/.emulationstation/themes/Pi-Station-MediEvil"
  "https://github.com/Renetrox/PiStation-The-Last-of-Us-Part-II--Ellie-Theme $HOME/.emulationstation/themes/PiStation-The-Last-of-Us-Part-II"
  "https://github.com/Renetrox/PiStation-RE4 $HOME/.emulationstation/themes/PiStation-RE4"
)

# ----------------------------
# Dependencias
# ----------------------------
for cmd in git dialog awk; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Falta '$cmd'. Instala con: sudo apt install $cmd"
    exit 1
  fi
done

mkdir -p "$MENU_DIR" "$ICON_DIR"

# ----------------------------
# Copiar menú e icono DESDE Pi-Station-X
# ----------------------------
install_pistation_menu() {

  local SRC_MENU="$PISTATION_THEME/layout/$MENU_FILE"
  local SRC_ICON="$PISTATION_THEME/layout/$ICON_FILE"

  if [ -f "$SRC_MENU" ]; then
    cp "$SRC_MENU" "$MENU_DIR/$MENU_FILE"
    chmod +x "$MENU_DIR/$MENU_FILE"
  else
    echo "ERROR: No se encontró $MENU_FILE en Pi-Station-X"
    return 1
  fi

  if [ -f "$SRC_ICON" ]; then
    cp "$SRC_ICON" "$ICON_DIR/$ICON_FILE"
    chmod 644 "$ICON_DIR/$ICON_FILE"
  else
    echo "ERROR: No se encontró $ICON_FILE en Pi-Station-X"
    return 1
  fi
}

# ----------------------------
# Registrar PiStation Menu
# ----------------------------
register_menu() {

  grep -q "<path>./$MENU_FILE</path>" "$GAMELIST" && return

  ENTRY=$(cat <<EOF
  <game>
    <path>./$MENU_FILE</path>
    <name>PiStation Menu</name>
    <desc>Layout customization modules, avatar selection and user name setup.
Módulos de personalización del layout, selección de avatar y definición del nombre de usuario.</desc>
    <image>$ICON_DIR/$ICON_FILE</image>
  </game>
EOF
)

  awk -v entry="$ENTRY" '
    /<\/gameList>/ { print entry }
    { print }
  ' "$GAMELIST" > "${GAMELIST}.tmp" && mv "${GAMELIST}.tmp" "$GAMELIST"
}

# ----------------------------
# Instalar / actualizar tema
# ----------------------------
process_theme() {
  local REPO_URL="$1"
  local DESTINO="$2"

  if [ -d "$DESTINO/.git" ]; then
    cd "$DESTINO" || return
    git fetch --all
    git reset --hard origin/$(git rev-parse --abbrev-ref HEAD)
    git clean -fd
    git pull
  else
    git clone "$REPO_URL" "$DESTINO"
  fi

  chmod -R 755 "$DESTINO"
}

# ----------------------------
# Desinstalar tema
# ----------------------------
uninstall_theme() {
  local DESTINO="$1"
  local THEME_NAME
  THEME_NAME=$(basename "$DESTINO")

  [ ! -d "$DESTINO" ] && return

  dialog --yesno "¿Deseas eliminar el tema $THEME_NAME?" 8 50 || return
  rm -rf "$DESTINO"
}

# ----------------------------
# Menú principal
# ----------------------------
OPCIONES=()
for tema in "${TEMAS[@]}"; do
  nombre=$(basename "$(echo "$tema" | awk '{print $2}')")
  OPCIONES+=("$nombre" "$nombre")
done

OPCIONES+=(
  "All" "Instalar / Actualizar todos"
  "Uninstall" "Desinstalar un tema"
  "Exit" "Salir"
)

SELECCION=$(dialog --title "PiStation Menu" \
  --menu "Selecciona una opción:" 20 60 12 \
  "${OPCIONES[@]}" 2>&1 >/dev/tty)

clear

case "$SELECCION" in
  "All")
    for tema in "${TEMAS[@]}"; do
      REPO=$(echo "$tema" | awk '{print $1}')
      DEST=$(echo "$tema" | awk '{print $2}')
      process_theme "$REPO" "$DEST"
    done
    ;;
  "Uninstall")
    OPCIONES_UNINSTALL=()
    for tema in "${TEMAS[@]}"; do
      nombre=$(basename "$(echo "$tema" | awk '{print $2}')")
      OPCIONES_UNINSTALL+=("$nombre" "$nombre")
    done

    THEME_TO_REMOVE=$(dialog --title "Desinstalar tema" \
      --menu "Selecciona un tema:" 20 60 10 \
      "${OPCIONES_UNINSTALL[@]}" 2>&1 >/dev/tty)

    for tema in "${TEMAS[@]}"; do
      DEST=$(echo "$tema" | awk '{print $2}')
      [ "$(basename "$DEST")" = "$THEME_TO_REMOVE" ] && uninstall_theme "$DEST"
    done
    ;;
esac

# ----------------------------
# PASO QUE FALTABA (EL CLAVE)
# ----------------------------
install_pistation_menu
register_menu

dialog --msgbox "Operación completada.\nReinicia EmulationStation para aplicar los cambios." 8 60
clear
