# Termux-banner

A simple, interactive Termux banner installer and customizer script for Android, developed by Aman Khan. Easily set up, personalize, or remove a stylish banner and prompt in your Termux terminal.

![T-banner demo](https://raw.githubusercontent.com/ak-alien/T-banner/refs/heads/main/src/demo.jpg)

## Features

- One-click installation of required packages and fonts
- Custom banner text with ANSI Shadow font
- Beautifully styled terminal prompt (PS1)
- Easy removal and restoration to Termux defaults
- Menu-driven, beginner-friendly interface

---

## Prerequisites

- **Termux** app installed on your Android device
- Internet connection (for downloading fonts and packages)
- Basic familiarity with running shell scripts in Termux

---

## Installation

1. **Download the Script**

```bash
pkg update && pkg upgrade -y
pkg install git -y
git clone https://github.com/ak-alien/T-banner
cd T-banner
chmod +x T-banner.sh
bash T-banner.sh
```


---

## Usage

When you run the script, you'll see a menu:

- **[^1] Install packages \& resources**
Installs required packages (`figlet`, `ruby`, `curl`) and the `lolcat` gem. Downloads the ANSI Shadow font for banner rendering.
- **[^2] Setup Banner**
Prompts you to enter your custom banner text, then generates and applies it to your Termux welcome message and prompt.
- **[^3] Remove Banner**
Restores the default Termux message and prompt.

---

## Example

After running and setting up, your Termux will display a custom, colorful banner and prompt every time you open a new session.

---

## Troubleshooting

- If you encounter font download errors, ensure your internet connection is active.
- To restore the default Termux appearance, simply use the "Remove Banner" option in the script menu.

## License

This project is released under the MIT License.

---

