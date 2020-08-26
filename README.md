# AllTheIcons

Inspired by [Every Icon](http://www.numeral.com/panels/everyicon.html), a digital art piece that will eventually display every 32×32 pixel black-and-white icon. Built for [#MegaFavNumbers](https://www.youtube.com/playlist?list=PLar4u0v66vIodqt3KSZPsYyuULD5meoAo).

AllTheIcons is an iOS app that lets you interact with the icon grid from Every Icon. It supports the following interactions:

- Tap and drag to draw on the grid (this works better if you have an Apple Pencil or a trackpad). Draw on black pixels to turn them white, and white pixels to turn them black.
- Drag the slider to see the images that correspond to different numbers. The upper left corner of the grid is the least significant bit, and the lower right corner of the grid is the most significant bit.
- Click the `+` or `-` buttons to increment or decrement the number, and the grid will update accordingly.

## A Note on Performance

AllTheIcons has not been tested on an iOS device, just the iOS simulator. It is quite slow in Debug mode, which I believe is due to safety checks inside the Swift-BigInt library. Run with the AllTheIcons Release scheme for interactive performance.

AllTheIcons uses the [Swift-BigInt](https://github.com/mkrd/Swift-BigInt) library:

<details>
<summary>Swift-BigInt License</summary>

>The MIT License (MIT)

>Copyright (c) 2019 mkrd

>Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

>The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
</details>