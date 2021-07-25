import os, strutils, terminal, common

proc delScript*(name: string) =
  ## Deletes an existing script.
  
  if not isValidFS():
    quit "This file structure appears to be incorrect. Wrong directory?", -1

  let
    uppername = name.capitalizeAscii
    lowername = name.toLower

  if not fileExists("scripts/$1.gdns" % uppername):
    quit "'$1' does not exist. (Nim-style case sensitivity?)" % uppername, -1

  echo "Are you sure you want to delete the script '$1'? (y/N)" % uppername
  case getch().toLowerAscii
  of 'y':
    removeFile("src/$1.nim" % lowername)
    removeFile("scripts/$1.gdns" % uppername)

    let contents = readFile("src/stub.nim")
    var stub = open("src/stub.nim", fmWrite)
    stub.write(contents.replace("import $1" % lowername, "").replace("\n\n", ""))
    stub.close()

    echo "Successfully deleted script '$1'." % uppername
  else:
    echo "Aborted."