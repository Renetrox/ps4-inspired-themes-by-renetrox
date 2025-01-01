#!/bin/bash

# Script: PS4-Inspired Themes by Renetrox
# Description: Manage and install EmulationStation themes inspired by PS4.

# Lista de repositorios y carpetas de destino
TEMAS=(
    "https://github.com/Renetrox/Pi-Station-X $HOME/.emulationstation/themes/Pi-Station-X"
    "https://github.com/Renetrox/Mk1 $HOME/.emulationstation/themes/Mk1"
    "https://github.com/Renetrox/Pi-Station-Batman $HOME/.emulationstation/themes/Pi-Station-Batman"
    "https://github.com/Renetrox/Pi-Station---MediEvil $HOME/.emulationstation/themes/Pi-Station-MediEvil"
    "https://github.com/Renetrox/PiStation-The-Last-of-Us-Part-II--Ellie-Theme $HOME/.emulationstation/themes/PiStation-The-Last-of-Us-Part-II"
    "https://github.com/Renetrox/PiStation-RE4 $HOME/.emulationstation/themes/PiStation-RE4"
)

# Verificar si git está instalado
if ! command -v git &> /dev/null; then
    echo "Git is not installed. Please install it before proceeding."
    exit 1
fi

# Verificar y crear la carpeta de temas si no existe
if [ ! -d "$HOME/.emulationstation/themes" ]; then
    echo "Creating themes directory at $HOME/.emulationstation/themes..."
    mkdir -p "$HOME/.emulationstation/themes"
fi

# Crear opciones de menú para el diálogo
OPCIONES=()
for i in "${!TEMAS[@]}"; do
    REPO_URL=$(echo "${TEMAS[$i]}" | awk '{print $1}')
    DESTINO=$(echo "${TEMAS[$i]}" | awk '{print $2}')
    OPCIONES+=("$(basename "$DESTINO")" "$REPO_URL $DESTINO")
done
OPCIONES+=("All themes")
OPCIONES+=("Exit")

# Mostrar el menú usando dialog
SELECCIONADO=$(dialog --title "Select a theme to install or update" --menu "Use arrows to navigate and press Enter to select:" 15 50 8 "${OPCIONES[@]}" 2>&1 >/dev/tty)

# Verificar si el usuario presionó "Exit"
if [ "$SELECCIONADO" == "Exit" ]; then
    echo "Exiting without making changes."
    exit 0
fi

# Función para procesar los temas
process_theme() {
    REPO_URL=$1
    DESTINO=$2

    echo "Processing theme: $REPO_URL"

    # Si el tema ya está instalado, buscar actualizaciones automáticamente
    if [ -d "$DESTINO/.git" ]; then
        echo "Theme already installed at $DESTINO."
        echo "Resetting and cleaning local changes..."
        cd "$DESTINO" || exit 1
        git fetch --all
        git reset --hard origin/$(git rev-parse --abbrev-ref HEAD)
        git clean -fd
        echo "Pulling latest updates..."
        if git pull; then
            echo "Theme updated successfully!"
        else
            echo "Error updating the theme. Check your internet connection or conflicts."
        fi
    else
        # Si el tema no está instalado, clonarlo
        echo "Installing theme from $REPO_URL..."
        git clone --progress "$REPO_URL" "$DESTINO"
        if [ $? -ne 0 ]; then
            echo "Error cloning the theme $REPO_URL. Check your internet connection."
        else
            echo "Theme installed successfully at $DESTINO!"
        fi
    fi

    chmod -R 755 "$DESTINO"
    echo "Processing $REPO_URL completed."
}

# Copiar el archivo de configuración si Pi-Station-X es seleccionado
copy_customize_script() {
    PI_STATION_X_DIR="$HOME/.emulationstation/themes/Pi-Station-X"
    SCRIPT_SOURCE="$PI_STATION_X_DIR/layout/Customize Pi Station X.sh"
    SCRIPT_DEST="$HOME/RetroPie/retropiemenu/Customize Pi Station X.sh"

    echo "Checking if the source script exists at $SCRIPT_SOURCE"
    if [ -f "$SCRIPT_SOURCE" ]; then
        echo "Copying Customize Pi Station X.sh to $SCRIPT_DEST..."
        cp "$SCRIPT_SOURCE" "$SCRIPT_DEST"
        chmod +x "$SCRIPT_DEST"  # Dar permisos de ejecución
        echo "Customization script copied successfully!"
    else
        echo "Customize Pi Station X.sh not found in $PI_STATION_X_DIR/layout."
    fi
}

# Buscar el tema seleccionado y procesarlo
if [ "$SELECCIONADO" == "All themes" ]; then
    # Procesar todos los temas
    for tema in "${TEMAS[@]}"; do
        REPO_URL=$(echo "$tema" | awk '{print $1}')
        DESTINO=$(echo "${tema}" | awk '{print $2}')
        process_theme "$REPO_URL" "$DESTINO"

        # Si Pi-Station-X fue seleccionado, copiar el script
        if [ "$(basename "$DESTINO")" == "Pi-Station-X" ]; then
            copy_customize_script
        fi
    done
else
    # Procesar un tema específico
    for tema in "${TEMAS[@]}"; do
        REPO_URL=$(echo "$tema" | awk '{print $1}')
        DESTINO=$(echo "${tema}" | awk '{print $2}')
        if [ "$(basename "$DESTINO")" == "$SELECCIONADO" ]; then
            process_theme "$REPO_URL" "$DESTINO"

            # Si Pi-Station-X fue seleccionado, copiar el script
            if [ "$(basename "$DESTINO")" == "Pi-Station-X" ]; then
                copy_customize_script
            fi
        fi
    done
fi

# Mostrar mensaje final
dialog --msgbox "Operation completed. Please restart EmulationStation to apply the changes." 10 50

echo "Operation completed."
