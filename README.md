# powerprompt-lite
A lightweight and customizable shell prompt designed to provide a Powerline-like experience.

## Installation
Download and run the installation script:
   ```bash
   curl -o install_prompt.sh https://raw.githubusercontent.com/yourusername/your-repository/main/install_prompt.sh
   chmod +x install_prompt.sh
   ./install_prompt.sh
   ```
## Configuration
Edit the configuration file `$HOME/.powerprompt/prompt_config.conf` at your local system
Your can use icons and colors from `$HOME/.powerprompt/styles.sh` or add your own.

## Usage
The prompt will be configured automatically upon login. You can manually apply changes by sourcing your .bashrc:
```bash
source ~/.bashrc
```

## Future Improvements
- Git Integration: Display branch names, commit statuses, and other Git-related information.

- Extended Customization: More configuration options for colors, symbols, and styles.

- Plugin System: Support for adding plugins for additional functionalities.

## Contributing
Contributions are welcome! Feel free to open issues or submit pull requests.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
