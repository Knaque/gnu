# gnu
GNU (Godot-Nim Utility) is a CLI for creating games in the Godot engine using the Nim programming language.

## Prerequisites
- Set the `GODOT_BIN` environment variable to point your Godot executable.

## Usage
1. Create a new project with `gnu init --name:"<project name>"`
2. Use the `gnu newScript --name=<component name> --node=<node type>` and `gnu delScript --name=<component name>` commands to create and delete scripts, and assign them to nodes in the Godot editor.
3. Build your scripts with `gnu build`. Run this command again whenever you'd like to see your changes.
4. Write your code in your favorite editor, do everything else in Godot!