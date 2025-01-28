# Minecraft Server Start Script

This is a Windows batch script to help you easily configure and start a Minecraft server. It includes options for custom memory allocation, port selection, and advanced server optimizations with Aikar's flags. The script also supports automatic restarts in case of crashes.

## Features

- **Memory Allocation**: Choose how much memory (RAM) to allocate to your server.
- **Port Configuration**: Customize the port your server listens on.
- **Aikar's Flags**: Enable optimized Java flags for improved server performance.
- **Automatic Restarts**: Automatically restart the server if it crashes or stops unexpectedly.
- **Custom Java Version**: Use a portable Java version without needing to install Java on your system.

## Getting Started

1. Place this script in the same folder as your Minecraft server `.jar` files.
2. If you want to use a custom Java version:
   - Download a JDK from [Adoptium](https://adoptium.net/en-GB/temurin/releases/?os=windows&arch=x64&package=jdk).
   - Extract the contents of the ZIP file into a `java` folder in the **root directory** where the script is located. Ensure the `java` folder contains subfolders like `bin`, `conf`, `include`, etc.
3. Double-click the script to run it.
4. Follow the on-screen prompts to configure your server or use the default settings.

## Requirements

- **Java**: Either have Java installed and added to your system's PATH, or use the custom Java option described above.
- **Minecraft Server `.jar` File**: Download the server `.jar` file from the [official Minecraft website](https://www.minecraft.net/en-us/download/server).

## How to Use

1. Run the script by double-clicking it.
2. You can choose to use the default settings or customize:
   - Memory allocation (default: 4 GB)
   - Server port (default: 25565)
   - Enable/disable Aikar's Flags (default: Enabled)
   - Enable/disable Auto-Restart (default: Enabled)
   - Select a specific `.jar` file from the current directory.
3. The server will start with the specified settings.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

## Troubleshooting

- **Java Not Found**: If the script cannot find Java:
  - Make sure Java is installed and properly added to the PATH.
  - Alternatively, download a JDK from [Adoptium](https://adoptium.net/en-GB/temurin/releases/?os=windows&arch=x64&package=jdk), extract the contents into a `java` folder in the **root directory** where the script is located, and try again.
- **No `.jar` Files Found**: Place your Minecraft server `.jar` file in the same folder as the script.

Your directory should look like this if you are using a portable java. Will look the exact same without the java folder if you're not using portable java 

## How your java directory should look
```
Minecraft Server ROOT/
├── run.bat                  # Your Minecraft server run script
├── java/                    # Custom Java version (optional)
│   ├── bin/
│   │   ├── java.exe         # Java executable
│   │   └── other Java files...
│   ├── conf/
│   ├── include/
│   ├── lib/
│   └── other JDK files...
├── server.jar               # Minecraft server .jar file
└── other files...           # Any additional files (logs, plugins, etc.)
```
## Contribution

Feel free to modify or distribute this script as you like!
