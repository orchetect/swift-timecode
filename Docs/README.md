# SwiftTimecode DocC Generation

This is published as a guide for maintainers to manually generate and publish documentation.

The docs generation procedure is mostly automated, but requires a handful of manual procedures that are not yet automated in order to build and publish.

> [!NOTE]
>
> In future, this method will be replaced with automatic docs generation and hosting on SwiftPackageIndex.

## Build

1.  Run the `build-docc-cached-preview.sh` command from Terminal from within the repo directory

    - If any DocC warnings are shown:

      1. resolve the issues in the codebase
      2. re-run the build script and repeat resolving issues until no more warnings are present
      3. make a commit
      4. repeat as necessary until all warnings are gone

    - When finished the generated docs path will be output to the console, ie:

      ```
      Generated combined documentation archive at:
        /var/folders/pk/3smbhvrd0p701_rpq3t0c_2r0000gn/T/tmp.Oq9smpNmnD/docs-webroot/swift-timecode
      ```

    - As well, a local web server on port 8080 will run to preview the documentation in a local web browser at this URL:

      http://localhost:8080/swift-timecode/documentation

2.  Press `Ctrl+C` in the Terminal window to shut down the local webserver and return to the shell prompt

3.  Navigate to the generated docs path using the path that was output to the console. For example:

    ```bash
    cd /var/folders/pk/3smbhvrd0p701_rpq3t0c_2r0000gn/T/tmp.Oq9smpNmnD/docs-webroot/swift-timecode
    ```

    Then to open this folder in the Finder:

    ```bash
    open .
    ```

4.  Within the generated docs, edit the root `index.html` file in a text editor.

    - Include a meta event to redirect to the documentation subpath. Within the `<head>` block, add this line:

      ```html
      <meta http-equiv="refresh" content="0; url=documentation/">
      ```

    - Near the end of the file, replace the `<p>` block with this block:

      ```html
      <p><a href="documentation/">Click here</a> to open documentation if you are not automatically redirected.</p>
      ```

## Publish

1.  Pull the remote `docs` branch and update it with the newly-generated docs.
2.  Remove all files within the `docs` subfolder.

3.  Copy all files from the generated docs to replace the old docs that were deleted.

4.  Make a commit on the `docs` branch with the target package version number in the commit message, ie: `3.1.4 Docs`.
5.  Push to remote `docs` branch.

    > GitHub Actions will automatically publish the site to GitHub Pages.