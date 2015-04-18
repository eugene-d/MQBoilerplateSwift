# MQBoilerplateSwift

`MQBoilerplateSwift` is a Swift framework containing all the code that I keep reusing across my iOS app projects. It's the exact same thing as `MQBoilerplate`, except that one is written in Objective-C.

## Installation

Currently, `MQBoilerplateSwift` can only be added to a project via `git submodule`.

In the Terminal, go to your Xcode project's folder, and then to wherever you want to clone the submodule:

```
cd path/to/project/Submodules
```

Then, type `git submodule add https://github.com/mattquiros/MQBoilerplateSwift.git`

## Cloning a project with MQBoilerplateSwift

* `git clone` the project repo and go (`cd`) to its folder.
* Run `git submodule update --init --recursive` to download the files from the `MQBoilerplateSwift` submodule.
* Open the `.xcodeproj`, or `.xcworkspace` if using Cocoapods. 
* In Xcode, expand to the folders *PROJECT_NAME > Libraries > MQBoilerplateSwift*.
* Keep only the `MQBoilerplateSwift.xcodeproj` in the project and remove references to the following files, **but DO NOT move them to the Trash:**
    * .gitignore
    * MQBoilerplateSwift (folder)
    * MQBoilerplateSwiftTests (folder)
* In the project target's *Build Phases > Target Dependencies*, click on the plus sign and add `MQBoilerplateSwift.framework`.
* In the project target's '*General* tab, scroll to `Embedded Binaries`, click on the plus sign, and add `MQBoilerplateSwift.framework`

## Checking out branches without MQBoilerplateSwift

If you `git checkout` to another branch that does not have `MQBoilerplateSwift` in it and run `git status` on that branch, you may see git complain that the `PROJECT_NAME/Libraries/MQBoilerplateSwift` folder is untracked (`??`). Simply delete the `MQBoilerplateSwift` folder to make git shut up.

See: [Issues with Submodules](http://git-scm.com/book/en/v2/Git-Tools-Submodules#Issues-with-Submodules)

## Usage