import os, common

proc clean*() =
  ## Remove files produced by building.
  
  ensureValidFS()

  removeDir(".nimcache")
  removeDir("src"/".nimcache")
  removeDir("src"/"godotapi")
  removeDir("_dlls")