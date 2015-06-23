# MQBoilerplateSwift

`MQBoilerplateSwift` is a Swift framework containing all the code that I keep reusing across my iOS app projects.

## Dependencies

This framework uses [Alamofire](https://github.com/Alamofire/Alamofire) under the hood to manage network requests. You must add the `Alamofire.framework` from `MQBoilerplateSwift` to your project's `Embedded Libraries` build phase.

## Installation

Currently, `MQBoilerplateSwift` can only be added to a project via `git submodule`.

* In the Terminal, go to your Xcode project's folder, and then to wherever you want to clone the submodule: `cd path/to/project/Submodules`
* Type `git submodule add https://github.com/mattquiros/MQBoilerplateSwift.git`
* Open your app's Xcode project.
* In Xcode, expand to the folder where you cloned `MQBoilerplateSwift`.
* In the top-level `MQBoilerplateSwift` folder, keep only the `.xcodeproj` and remove references to the following files, **but DO NOT move them to the Trash:**
    * .gitignore
    * MQBoilerplateSwift (folder)
    * MQBoilerplateSwiftTests (folder)
* In the project target's *Build Phases > Target Dependencies*, click on the plus sign and add `MQBoilerplateSwift.framework`.
* In the project target's *General* tab, scroll to `Embedded Binaries`, click on the plus sign, and add `MQBoilerplateSwift.framework`

## Cloning a project with MQBoilerplateSwift

* `git clone` the project repo and go (`cd`) to its folder.
* Run `git submodule update --init --recursive` to download the files from the `MQBoilerplateSwift` submodule.

## Versioning

If you are cloning a project that I built with `MQBoilerplateSwift`, make sure that your local copy of the framework is the correct version.

To find out what version of `MQBoilerplateSwift` you should use, go to the app's `README.md` file. Then, `git checkout` the specified tag.

```
$ cd MQBoilerplateSwift
$ git fetch --tags
$ git checkout tags/VERSION_NUMBER
```

## Checking out branches without MQBoilerplateSwift

If you `git checkout` to another branch that does not have `MQBoilerplateSwift` in it and run `git status` on that branch, you may see git complain that the `PROJECT_NAME/Libraries/MQBoilerplateSwift` folder is untracked (`??`). Simply delete the `MQBoilerplateSwift` folder to make git shut up.

See: [Issues with Submodules](http://git-scm.com/book/en/v2/Git-Tools-Submodules#Issues-with-Submodules)

## Usage