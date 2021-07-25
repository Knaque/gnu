import os, strutils, common, algorithm

proc getValidNodes(): seq[string] =
  # get the name of every godot node by walking the godotapi directory
  for f in walkDir("src/godotapi"):
    if f.path.endsWith(".nim"):
      result.add f.path.split("\\")[^1][0..^5]

proc probableObjName(node: string): string =
  # this spits out what is *probably* the object name of a given node
  for x in node.split("_"):
    result.add x.capitalizeAscii

proc newScript*(name: string, node: string) =
  ## Creates a new script.
  
  if not isValidFS():
    quit "This file structure appears to be incorrect. Wrong directory?", -1

  genGodotApi()

  let validNodes = getValidNodes()

  let
    uppername = name.capitalizeAscii
    lowername = name.toLower
    lowernode = node.toLower

  if validNodes.binarySearch(node) == -1:
    quit "'$1' is not a valid node type." % node, -1

  # create the .nim file
  writeFile("src/$1.nim" % lowername,
"""import godot
import godotapi / [$1]

gdobj $2 of $3:

  method ready*() =
    discard

  method process*(delta: float64) =
    discard
""" % [lowernode, uppername, lowernode.probableObjName])

  # create the .gdns file
  writeFile("scripts/$1.gdns" % uppername,
"""[gd_resource type="NativeScript" load_steps=2 format=2]

[ext_resource path="res://nimlib.gdnlib" type="GDNativeLibrary" id=1]

[resource]

resource_name = "$1"
library = ExtResource( 1 )
class_name = "$1"

""" % uppername)

  # append the new component to the stub
  var stub = open("src/stub.nim", fmAppend)
  stub.write "\nimport " & lowername
  stub.close()

  echo "Created new script '$1' of type '$2'." % [uppername, lowernode]