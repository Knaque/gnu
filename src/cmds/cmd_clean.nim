import os

proc clean*() =
  ## Remove files produced by building.
  removeDir(".nimcache")
  removeDir("src"/".nimcache")
  removeDir("src"/"godotapi")
  removeDir("_dlls")