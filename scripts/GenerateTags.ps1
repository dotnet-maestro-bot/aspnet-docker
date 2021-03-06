#!/usr/bin/env pwsh
#requires -version 4
param(
    [Parameter()]
    [Alias('b')]
    [ValidateSet('master', 'dev')]
    [string]$Branch
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 1

$repoRoot = Split-Path -Parent $PSScriptRoot
if (!$Branch) {
    $Branch = "$(& git rev-parse --abbrev-ref HEAD)"
}

if (!$Branch) {
    Write-Warning 'Could not automatically determine branch. Falling back to "master". Add -Branch <BRANCH> to override'
    $Branch = 'master'
}


& docker run --rm `
    -v /var/run/docker.sock:/var/run/docker.sock `
    -v "${repoRoot}:/repo" `
    -w /repo `
    microsoft/dotnet-buildtools-prereqs:image-builder-debian-20180306162116 `
    generateTagsReadme `
    --update-readme `
    "https://github.com/aspnet/aspnet-docker/blob/${Branch}"
