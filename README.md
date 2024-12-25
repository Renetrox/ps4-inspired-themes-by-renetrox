PS4 Inspired Themes by Renetrox

This repository contains a collection of PS4-inspired themes for EmulationStation on RetroPie. It includes a script to easily install and manage these themes via the RetroPie Menu.
Requirements

    RetroPie installed on your device.
    Git installed on your system.
    Access to the terminal.

Installation

Follow these steps to install the themes and configure the script on RetroPie:
Step 1: Clone the repository

First, clone this repository onto your RetroPie device. Open the terminal and run the following command:

cd /home/$(whoami)/RetroPie/retropiemenu
git clone https://github.com/Renetrox/ps4-inspired-themes-by-renetrox.git

This will download the repository files to the correct directory, regardless of your device's username.
Step 2: Make the script executable

Navigate to the ps4-inspired-themes-by-renetrox folder you just cloned, and grant execution permissions to the script. Run the following commands in the terminal:

cd /home/$(whoami)/RetroPie/retropiemenu/ps4-inspired-themes-by-renetrox
chmod +x ps4-inspired-themes-by-renetrox.sh

Step 3: Install the themes

To install the themes, run the script directly from the terminal with the following command:

./ps4-inspired-themes-by-renetrox.sh

The script will install and update the themes available in the repository.
Step 4: Access themes from RetroPie

Once the themes have been installed correctly, you can access them from EmulationStation by restarting or opening the RetroPie menu.

The themes will be available at the path /home/$(whoami)/.emulationstation/themes/.
Step 5: Customization (optional)

To customize the Pi-Station-X theme and other PS4-inspired themes, you can use the customization script located at:

/home/$(whoami)/.emulationstation/themes/Pi-Station-X/layout/Customize Pi Station X.sh

This script is run from RetroPie Menu or EmulationStation to customize the look of your theme.
Step 6: Restart EmulationStation (if necessary)

If you make changes to the themes, you may need to restart EmulationStation for the changes to take effect. To restart EmulationStation:

    From the terminal:

systemctl restart emulationstation

    Or from RetroPie Menu.

Using RetroPie Menu

Once the script is installed, you can access it from the RetroPie Menu. Upon selecting the script, an interactive menu will appear where you can choose which themes to install or update.
Project Structure

ps4-inspired-themes-by-renetrox/
│
├── ps4-inspired-themes-by-renetrox.sh   # Script to install and manage themes
├── Pi-Station-X/                       # Directory containing the Pi-Station-X theme
├── Mk1/                                # Directory containing the Mk1 theme
├── Pi-Station-Batman/                  # Directory containing the Pi-Station-Batman theme
├── Pi-Station-MediEvil/                # Directory containing the Pi-Station-MediEvil theme
└── PiStation-The-Last-of-Us-Part-II/   # Directory containing the PiStation-The-Last-of-Us-Part-II theme

Contributions

Contributions are welcome! If you have improvements, fixes, or new themes you want to add, feel free to fork this repository and submit a pull request.

_______________________________________________________________________________________________________________________________________________
Este repositorio contiene una colección de temas inspirados en PS4 para EmulationStation en RetroPie. Incluye un script para instalar y gestionar estos temas fácilmente a través de RetroPie Menu.
Requisitos

    RetroPie instalado en tu dispositivo.
    Git instalado en tu sistema.
    Acceso a la terminal.

Instalación

Sigue estos pasos para instalar los temas y configurar el script en RetroPie:
Paso 1: Clonar el repositorio

Primero, clona este repositorio en tu dispositivo RetroPie. Abre la terminal y ejecuta el siguiente comando:

cd /home/$(whoami)/RetroPie/retropiemenu
git clone https://github.com/Renetrox/ps4-inspired-themes-by-renetrox.git

Esto descargará los archivos del repositorio en el directorio adecuado, sin importar el nombre de usuario de tu dispositivo.
Paso 2: Hacer el script ejecutable

Dirígete a la carpeta ps4-inspired-themes-by-renetrox que acabas de clonar y otorga permisos de ejecución al script. Ejecuta estos comandos en la terminal:

cd /home/$(whoami)/RetroPie/retropiemenu/ps4-inspired-themes-by-renetrox
chmod +x ps4-inspired-themes-by-renetrox.sh

Paso 3: Instalar los temas

Para instalar los temas, puedes ejecutar el script directamente desde la terminal con el siguiente comando:

./ps4-inspired-themes-by-renetrox.sh

El script instalará y actualizará los temas disponibles en el repositorio.
Paso 4: Acceder a los temas desde RetroPie

Una vez que los temas se hayan instalado correctamente, podrás acceder a ellos desde EmulationStation al reiniciar o al abrir el menú de RetroPie.

Los temas estarán disponibles en la ruta /home/$(whoami)/.emulationstation/themes/.
Paso 5: Personalización (opcional)

Para personalizar el tema Pi-Station-X y otros temas inspirados en PS4, puedes usar el script de personalización que se encuentra en:

/home/$(whoami)/.emulationstation/themes/Pi-Station-X/layout/Customize Pi Station X.sh

Este script se ejecuta desde RetroPie Menu o EmulationStation para personalizar el aspecto de tu tema.
Paso 6: Reiniciar EmulationStation (si es necesario)

Si realizas cambios en los temas, es posible que necesites reiniciar EmulationStation para que los cambios surtan efecto. Para reiniciar EmulationStation:

    Desde la terminal:

systemctl restart emulationstation

    O desde RetroPie Menu.

Uso de RetroPie Menu

Una vez que hayas instalado el script, podrás acceder a él desde RetroPie Menu. Al seleccionar el script en RetroPie Menu, aparecerá un menú interactivo donde podrás elegir qué temas instalar o actualizar.
Estructura del Proyecto

ps4-inspired-themes-by-renetrox/
│
├── ps4-inspired-themes-by-renetrox.sh   # Script para instalar y gestionar los temas
├── Pi-Station-X/                       # Directorio con el tema Pi-Station-X
├── Mk1/                                # Directorio con el tema Mk1
├── Pi-Station-Batman/                  # Directorio con el tema Pi-Station-Batman
├── Pi-Station-MediEvil/                # Directorio con el tema Pi-Station-MediEvil
└── PiStation-The-Last-of-Us-Part-II/   # Directorio con el tema PiStation-The-Last-of-Us-Part-II

Contribuciones

¡Las contribuciones son bienvenidas! Si tienes mejoras, correcciones o nuevos temas que quieras agregar, siéntete libre de hacer un fork de este repositorio y enviar un pull request.
