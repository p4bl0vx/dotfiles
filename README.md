# dotfiles

Automatiza la configuración de tu entorno de escritorio Linux (KDE Plasma) con un solo script. Este repositorio contiene mis dotfiles personalizados y un script de instalación que deja tu sistema listo para usar, con temas, aplicaciones, atajos y apariencia profesional.

## Características principales

- **Instalación automática de entorno KDE**: Incluye temas, iconos, decoraciones de ventana y configuración de terminal.
- **Instalación de aplicaciones esenciales**: Brave, Discord, Telegram, Spotify, Obsidian, Kitty, Tmux, Flameshot, KeepassXC, y más.
- **Gestión de dotfiles**: Copia y adapta automáticamente los archivos de configuración a tu usuario.
- **Soporte para wallpapers**: Copia tu wallpaper a `~/.wallpapers/wallpaper.jpg` y lo configura en KDE.
- **Automatización de temas**: Descarga e instala temas Catppuccin, Layan, Tela, etc.

## Instalación rápida

1. Clona el repositorio:
   ```bash
   git clone https://github.com/p4bl0vx/dotfiles.git
   cd dotfiles
   ```

2. (Opcional) Personaliza `wallpaper.jpg` en la raíz del repo.

3. Ejecuta el script de instalación:
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```

4. Sigue las instrucciones en pantalla y espera a que termine.

## Requisitos

- Distribución basada en Debian/Ubuntu (probado en Kali Linux)

## Personalización

- Modifica los archivos en `dotfiles/` para adaptar atajos, temas, terminal, etc.
- El script detecta tu usuario y adapta los paths automáticamente.

## Créditos

- Temas: [Catppuccin](https://github.com/catppuccin), [Layan](https://github.com/vinceliuice/Layan-kde), [Tela Icons](https://github.com/vinceliuice/Tela-icon-theme)