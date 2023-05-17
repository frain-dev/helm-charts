# Set version
tag=$1

# Tag & Push.
git tag "$tag"
git push origin "$tag"
