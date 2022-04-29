# winget-publish-action
GitHub Action to deploy packages to Winget using Winget-Create


## Sample

```yaml
    - name: Winget Publish
      uses: isaacrlevin/winget-publish-action@1.0
      with:
        publish-type: "Update"
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