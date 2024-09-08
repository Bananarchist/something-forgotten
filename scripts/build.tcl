#!/usr/bin/tclsh

# Create the dist directory
file mkdir dist
file mkdir dist/js
file mkdir dist/css

# Build elm
exec elm make src/Main.elm --output=dist/js/main.js

# Copy the css
file copy -force src/style.css dist/css/style.css

# Copy the html
file copy -force src/index.html dist/index.html
