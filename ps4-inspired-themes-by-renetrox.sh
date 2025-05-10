#!/bin/bash

# Script: PS4-Inspired Themes by Renetrox v3
# Funciones: Instalar, actualizar y desinstalar temas para EmulationStation con estilo PS4

TEMAS=(
    "https://github.com/Renetrox/Pi-Station-X $HOME/.emulationstation/themes/Pi-Station-X"
    "https://github.com/Renetrox/Mk1 $HOME/.emulationstation/themes/Mk1"
    "https://github.com/Renetrox/Pi-Station-Batman $HOME/.emulationstation/themes/Pi-Station-Batman"
    "https://github.com/Renetrox/Pi-Station---MediEvil $HOME/.emulationstation/themes/Pi-Station-MediEvil"
    "https://github.com/Renetrox/PiStation-The-Last-of-Us-Part-II--Ellie-Theme $HOME/.emulationstation/themes/PiStation-The-Last-of-Us-Part-II"
    "https://github.com/Renetrox/PiStation-RE4 $HOME/.emulationstation/themes/PiStation-RE4"
)

# Verificaciones
for cmd in git dialog; do
    if ! command -v $cmd &> /dev/null; then
        echo "Falta el comando '$cmd'. Intenta: sudo apt install $cmd"
        exit 1
    fi
done

mkdir -p "$HOME/.emulationstation/themes"

copy_customize_script() {
    local THEME_DIR="$HOME/.emulationstation/themes/Pi-Station-X"
    local MENU_DIR="$HOME/RetroPie/retropiemenu"
    local SCRIPT_SOURCE="$THEME_DIR/layout/PiStation_menu.sh"
    local SCRIPT_DEST="$MENU_DIR/PiStation_menu.sh"

    mkdir -p "$MENU_DIR"

    if [ -f "$SCRIPT_SOURCE" ]; then
        cp "$SCRIPT_SOURCE" "$SCRIPT_DEST"
        chmod +x "$SCRIPT_DEST"
        echo "✓ PiStation_menu.sh copiado a retropiemenu."
    else
        echo "✗ No se encontró PiStation_menu.sh."
    fi
}

process_theme() {
    local REPO_URL="$1"
    local DESTINO="$2"
    local THEME_NAME
    THEME_NAME=$(basename "$DESTINO")

    echo "Procesando $THEME_NAME..."

    if [ -d "$DESTINO/.git" ]; then
        echo "Actualizando $THEME_NAME..."
        cd "$DESTINO" || return
        git fetch --all
        git reset --hard origin/$(git rev-parse --abbrev-ref HEAD)
        git clean -fd
        if git pull; then
            echo "✓ $THEME_NAME actualizado."
        else
            echo "✗ Error al actualizar $THEME_NAME."
        fi
    else
        echo "Instalando $THEME_NAME..."
        git clone "$REPO_URL" "$DESTINO"
        if [ $? -eq 0 ]; then
            echo "✓ $THEME_NAME instalado."
        else
            echo "✗ Error al instalar $THEME_NAME."
            return
        fi
    fi

    chmod -R 755 "$DESTINO"

    if [ "$THEME_NAME" == "Pi-Station-X" ]; then
        copy_customize_script
    fi
}

uninstall_theme() {
    local DESTINO="$1"
    local THEME_NAME
    THEME_NAME=$(basename "$DESTINO")

    if [ ! -d "$DESTINO" ]; then
        echo "✗ El tema $THEME_NAME no está instalado."
        return
    fi

    dialog --yesno "¿Deseas eliminar el tema $THEME_NAME?" 8 50
    if [ $? -eq 0 ]; then
        rm -rf "$DESTINO"
        echo "✓ Tema $THEME_NAME eliminado."

        if [ "$THEME_NAME" == "Pi-Station-X" ]; then
            local SCRIPT="$HOME/RetroPie/retropiemenu/PiStation_menu.sh"
            if [ -f "$SCRIPT" ]; then
                rm "$SCRIPT"
                echo "✓ PiStation_menu.sh eliminado del menú."
            fi
        fi
    else
        echo "✗ Operación cancelada."
    fi
}

# Menú principal
OPCIONES=()
for tema in "${TEMAS[@]}"; do
    nombre=$(basename "$(echo "$tema" | awk '{print $2}')")
    OPCIONES+=("$nombre" "$nombre")
done
OPCIONES+=("All" "Instalar/Actualizar todos")
OPCIONES+=("Uninstall" "Desinstalar un tema")
OPCIONES+=("Exit" "Salir")

SELECCION=$(dialog --title "Temas PS4 by Renetrox" --menu "Selecciona una opción:" 20 60 12 "${OPCIONES[@]}" 2>&1 >/dev/tty)

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
        THEME_TO_REMOVE=$(dialog --title "Desinstalar tema" --menu "Selecciona un tema para eliminar:" 20 60 10 "${OPCIONES_UNINSTALL[@]}" 2>&1 >/dev/tty)

        for tema in "${TEMAS[@]}"; do
            DEST=$(echo "$tema" | awk '{print $2}')
            if [ "$(basename "$DEST")" == "$THEME_TO_REMOVE" ]; then
                uninstall_theme "$DEST"
                break
            fi
        done
        ;;
    "Exit")
        echo "Saliendo..."
        exit 0
        ;;
    *)
        for tema in "${TEMAS[@]}"; do
            REPO=$(echo "$tema" | awk '{print $1}')
            DEST=$(echo "$tema" | awk '{print $2}')
            if [ "$(basename "$DEST")" == "$SELECCION" ]; then
                process_theme "$REPO" "$DEST"
                break
            fi
        done
        ;;
esac

dialog --msgbox "Operación completada. Reinicia EmulationStation para aplicar los cambios." 8 50
clear
