
# react-native-simple-share

## Getting started

`$ npm install react-native-simple-share --save`

### Mostly automatic installation

`$ react-native link react-native-simple-share`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-simple-share` and add `RNSimpleShare.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNSimpleShare.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Cocoapods

1. Add the RNSimpleShare plugin dependency to your `Podfile`, pointing at the path where NPM installed it

    ```ruby
    pod 'RNSimpleShare', :path => '../node_modules/react-native-simple-share'
    ```

2. Run `pod install`

*NOTE: The RNSimpleShare `.podspec` depends on the `React` pod, and so in order to ensure that it can correctly use the version of React Native that your app is built with, please make sure to define the `React` dependency in your app's `Podfile` as explained [here](https://facebook.github.io/react-native/docs/integration-with-existing-apps.html#podfile).*

## Usage
```javascript
import RNSimpleShare from 'react-native-simple-share';
```

#### Use RNSimpleShare simply by calling:
    return new Promise(function (resolve, reject) {
      RNSimpleShare.share({
        title: 'This is my title',
        description: 'This is my description',
        url: 'http://google.com',
        imageUrl: 'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png',
        imageBase64: 'Raw base64 encoded image data',
        image: 'Name of the image in the app bundle',
        file: 'Path to file you want to share',
        subject: 'This is my subject for email', 
        excludedActivityTypes: ['postToTwitter', 'print'],
        anchor: React.findNodeHandle(this.refs.share), // iPad only
      },
      function (error) {
        reject(error);
      },
      function (success, method) {
        resolve({success, method});
        if (!success) {
          // send failure message
        } else {
          // send success message
        }
      });
    });
      

##### Note:
- Only provide one image type to the options argument. If multiple image types are provided, image will be used.
- Anchor is optional and only applicable for iPad. Popup will be centered by default if anchor is not provided.
- If you decide to add a subject, it will be used; however if you don't, RNSimpleShare will seek out your app name and use that as the subject.

#### ExcludedActivityTypes params
```javascript
  'postToFacebook'
  'postToTwitter'
  'postToFlickr'   
  'postToVimeo'     
  'postToTencentWeibo' 
  'postToWeibo'        
  'postToPinterest'
  'message' 
  'airDrop'
  'mail'             
  'assignToContact'  
  'saveToCameraRoll'  
  'addToReadingList'
  'print'           
  'copyToPasteboard'
  'openInIBooks'
```

Note: `postToPinterest` is a custom one that is created in the implementation file

## License

#### MIT License (MIT)

Copyright (c) 2017 Jason Noah Choi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

