import os, osproc, strutils, times, godotapigen

proc genGodotApi*() =
  ## Generates the Godot API. Run this command manually when something like `gnu init` fails.
  let godotBin = getEnv("GODOT_BIN")
  if godotBin.len == 0:
    quit "GODOT_BIN environment variable is not set!", -1
  if not fileExists(godotBin):
    quit "Invalid GODOT_BIN path: " & godotBin, -1

  const targetDir = "src"/"godotapi"
  createDir(targetDir)

  const jsonFile = targetDir/"api.json"

  if not fileExists(jsonFile) or godotBin.getLastModificationTime() > jsonFile.getLastModificationTime():
    # pragmagic's original nakefile was broken here - it works now.
    discard execCmd("$1 --gdnative-generate-json-api $2" % [godotBin, jsonFile])

    if not fileExists(jsonFile):
      quit "Failed to generate api.json", -1

    genApi(targetDir, jsonFile)
    echo "Godot API generated successfully."
  else:
    echo "Godot API already exists; No generation necessary."

proc isValidFS*(): bool =
  fileExists("project.godot") and fileExists("nimlib.gdnlib") and dirExists("src")