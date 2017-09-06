middleman build
for f in $(find build -name '*.html'); do
  echo "CRITICIZING $f"
  cat $f | critical --base build --folder build --inline --minify > $f.1 && mv $f.1 $f
done
