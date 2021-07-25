import common, os, osproc, strutils

proc build*() =
  ## Builds your scripts for the current platform.
  genGodotApi()
  let bitsPostfix {.used.} = when sizeof(int) == 8: "_64" else: "_32"
  let libFile =
    when defined(windows):
      "nim" & bitsPostfix & ".dll"
    elif defined(ios):
      "nim_ios" & bitsPostfix & ".dylib"
    elif defined(macosx):
      "nim_mac.dylib"
    elif defined(android):
      "libnim_android.so"
    elif defined(linux):
      "nim_linux" & bitsPostfix & ".so"
    else: nil
  createDir("_dlls")
  setCurrentDir("src")
  quit execCmd("nimble c ../src/stub.nim -o:../_dlls/$1" % libFile)