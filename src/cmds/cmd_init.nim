import os, osproc, strutils, common

proc init*(name: string) =
  ## Initializes a new Godot-Nim project.

  let dirName = name.toLowerAscii.replace(" ", "_")

  if (
    let errorCode = execCmd(
      "git clone --depth=1 https://github.com/knaque/godot-nim-stub.git $1" %
        dirName
    )
    errorCode != 0
  ): quit errorCode
  
  setCurrentDir(getCurrentDir()/dirName)

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