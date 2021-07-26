import cligen
import cmds/[cmd_build, cmd_clean, cmd_delscript, cmd_init, cmd_newscript, common]

dispatchMulti(
  [init, help={"name": "The name for your new project.",
    "here": "Initialize the project in the current directory."}
  ],
  [newScript, help={"name": "The name for the new script",
    "node": "The Godot node type for the new script"}
  ],
  [delScript, help={"name": "The name of the script you want to delete"}],
  [build],
  [clean],
  [genGodotApi]
)