# Set version
tag=$1

# Commit version number & push
git commit -m "Bump version to $tag"
git push origin

# Tag & Push.
git tag "$tag"
git push origin "$tag"
