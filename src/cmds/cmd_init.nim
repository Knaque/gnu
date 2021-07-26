import os, osproc, strutils, common

proc init*(name: string, here = false) =
  ## Initializes a new Godot-Nim project.

  let rootDir =
    if here: "."
    else: name.toLowerAscii.replace(" ", "-")
  let tempDir = rootDir/"temp"

  if (
    let errorCode = execCmd(
      "git clone --depth=1 https://github.com/knaque/godot-nim-stub.git $1" %
        tempDir
    )
    errorCode != 0
  ): quit errorCode
  
  for dir in ["fonts", "scripts", "src", ".vscode"]:
    moveDir(tempDir/dir, rootDir/dir)
  for file in ["default_env.tres", "fps_counter.tscn", "icon.png", "icon.png.import", "main.tscn", "nimlib.gdnlib", "project.godot", "README.md", "scene.tscn", ".gitignore"]:
    moveFile(tempDir/file, rootDir/file)
  
  removeDir(tempDir)

  setCurrentDir(getCurrentDir()/rootDir)

  writeFile("project.godot",
"""; Engine configuration file.
; It's best edited using the editor UI and not directly,
; since the parameters that go here are not all obvious.
;
; Format:
;   [section] ; section goes between []
;   param=value ; assign values to parameters

config_version=4

[application]

config/name="$1"
run/main_scene="res://main.tscn"
config/icon="res://icon.png"

[gdnative]

singletons=[  ]

[rendering]

environment/default_environment="res://default_env.tres"
""" % name)

  genGodotApi()