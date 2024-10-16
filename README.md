# JSRingView
![](https://img.shields.io/badge/Platform-iOS-blue) ![](https://img.shields.io/badge/Swift%20Package%20Manager-Compatible-green) ![](https://img.shields.io/badge/UIKit-purple) ![](https://img.shields.io/badge/Swift-purple)

![](https://github.com/jsantolaria/JSRingView/blob/main/ig_style.GIF)


JSRingView reproduces the animated ring of Instagram stories when loading.
Customization is also possible.

## Installation

### Swift Package Manager

The Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

Once you have your Swift package set up, adding JSRingView as a dependency is as easy as adding it to the dependencies value of your Package.swift or the Package list in Xcode.
```
https://github.com/jsantolaria/JSRingView
```

## Usage 
```
import JSRingView

let ringView = JSRingView()
view.addSubview(ringView)
ringView.frame = .init(x: 0, y: 0, width: 64, height: 64)
ringView.startAnimating()
```

To stop the animation:
```
ringView.stopAnimating(soft: true)
```
`Soft` parameter is optional, the default value is true. 
When setted to true, animation will be stopped only when the ring will be filled.



Custom appearance is possible:

![](https://github.com/jsantolaria/JSRingView/blob/main/examples.GIF)

Example:
```
ringView.appearance = .init(color: .black, ringThickness: .relative(0.12))
ringView.animation = .init(speed: 1.25, segmentsCount: 64, segmentsCap: .butt)
```

Note that Mario photo is added manually, JSRingView manages only the ring. 


A more detailed readme will come later.

To understand the process on how to reproduce this animation:
https://medium.com/@jp.santolaria/how-to-reproduce-instagram-stories-ring-animation-in-swift-31218aac2e91

## License

[MIT](https://choosealicense.com/licenses/mit/)
