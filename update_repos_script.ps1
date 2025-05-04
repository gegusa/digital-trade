$branch = "master"

Write-Host "Updating all submodules to branch '$branch'..."

$submodules = git config --file .gitmodules --get-regexp path | ForEach-Object { $_.Split(" ")[1] }

foreach ($submodule in $submodules) {
    Write-Host "Updating submodule: $submodule"

    Set-Location $submodule

    git checkout $branch
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to checkout branch '$branch' in $submodule"
    }

    git pull origin $branch
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to pull latest changes for $submodule"
    }

    Set-Location ../..
}

Write-Host "Adding updated submodules to the index..."
git add .

Write-Host "Committing changes..."
git commit -m "Updated submodules to the latest commits from branch '$branch'" 2>$null

if ($LASTEXITCODE -ne 0) {
    Write-Host "No changes to commit"
}

Write-Host "Done."
