# winget-publish-action
GitHub Action to deploy packages to Winget using Winget-Create

## Samples

### Create new package version from existing Winget Manifest
```yaml
    - name: Winget Publish
      uses: isaacrlevin/winget-publish-action@1.0
      with:
        publish-type: "Update"
        user: "isaacrlevin"
        package: "presencelight"
        version: "5.4.11.0"
        url: "https://github.com/isaacrlevin/presencelight/releases/download/Desktop-v5.4.11/PresenceLight.Package_5.4.11.0_x64_x86_ARM64.appxbundle"
        token: ${{ secrets.WINGETCREATE_TOKEN }}
````


### Create new Package that does not currently exist in Manifest Repo
```yaml
    - name: Winget Publish
      uses: isaacrlevin/winget-publish-action@1.0
      with:
        publish-type: "Create"
        user: "isaacrlevin"
        package: "presencelight"
        version: "5.4.11.0"
        url: "https://github.com/isaacrlevin/presencelight/releases/download/Desktop-v5.4.11/PresenceLight.Package_5.4.11.0_x64_x86_ARM64.appxbundle"
        arch: x64
        installer-type: "appx"
        publisher: "Isaac Levin"
        package-name: "PresenceLight"
        license: "MIT License"
        short-description: "PresenceLight is a solution to broadcast your various statuses to light bulbs."
        token: ${{ secrets.WINGETCREATE_TOKEN }}
````