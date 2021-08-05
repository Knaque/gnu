import os, strutils, common, algorithm, sequtils

proc getValidNodes(): seq[string] =
  # get the name of every godot node by walking the godotapi directory
  for f in walkDir("src/godotapi"):
    if f.path.endsWith(".nim"):
      result.add f.path.replace("\\", "/").split("/")[^1][0..^5]
  result.sort()

proc probableObjName(node: string): string =
  # this spits out what is *probably* the object name of a given node
  for x in node.split("_"):
    result.add x.capitalizeAscii()

proc newScript*(name: string, node: string) =
  ## Creates a new script.
  
  # Aborts if the cwd does not appear to match a valid godot-nim project.
  ensureValidFS()

  # (re)generate the Godot API if necessary
  genGodotApi()

  # all valid node names
  let validNodes = getValidNodes()
  # node names w/o underscores
  let validNodesClean = validNodes.map(
    proc(x: string): string = x.replace("_", "")
  )

  let
    uppername = name.capitalizeAscii()
    lowername = name.toLower()
    # the node param, lowercase and w/o underscores
    cleannode = node.toLower().replace("_", "")

  # get the index of the node param, if it's a real node
  var truenodePos = validNodesClean.binarySearch(cleannode)
  if truenodePos == -1:
    quit "'$1' is not a valid node type." % cleannode, -1
  
  # get the name of the node (nim file) as prescribed by the godot api
  let truenode = validNodes[truenodePos]
  
  if fileExists("src/$1.nim" % lowername) or fileExists("scripts/$1.gdns" % uppername):
    quit "Script '$1' already exists." % uppername, -1

  # create the .nim file
  writeFile("src/$1.nim" % lowername,
"""import godot
import godotapi / [$1]

gdobj $2 of $3:

  method ready*() =
    discard

  method process*(delta: float64) =
    discard
""" % [truenode, uppername, truenode.probableObjName()])

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
  # var stub = open("src/stub.nim", fmAppend)
  # stub.write "\nimport " & lowername
  # stub.close()

  var stubLines = toSeq(lines("src/stub.nim"))
  stubLines = stubLines.filterIt(it != "")
  var stub = open("src/stub.nim", fmWrite)
  for line in stubLines:
    stub.write(line & '\n')
  stub.write("import " & lowername & '\n')
  stub.close()

  echo "Created new script '$1' of type '$2'." % [uppername, cleannode]