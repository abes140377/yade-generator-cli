#!/bin/bash
# Runs `mason bundle` to generate bundles for all bricks within the top level bricks directory.

# Create Dart Frog Brick
mason bundle -s git https://github.com/abes140377/yade-project-generator-cli --git-path bricks/create_dart_frog -t dart -o packages/dart_frog_cli/lib/src/commands/create/templates

dart format ./packages/dart_frog_cli
