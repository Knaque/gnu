# Package

version       = "0.1.0"
author        = "Knaque"
description   = "Godot-Nim Utility - Godot gamedev with Nim"
license       = "MIT"
srcDir        = "src"
bin           = @["gnu"]


# Dependencies

requires "nim >= 1.4.8"
requires "godot >= 0.7.21 & < 0.8.0"
requires "cligen >= 1.5.6"