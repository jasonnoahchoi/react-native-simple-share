
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


#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNSimpleSharePackage;` to the imports at the top of the file
  - Add `new RNSimpleSharePackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-simple-share'
  	project(':react-native-simple-share').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-simple-share/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-simple-share')
  	```

#### Windows
[Read it! :D](https://github.com/ReactWindows/react-native)

1. In Visual Studio add the `RNSimpleShare.sln` in `node_modules/react-native-simple-share/windows/RNSimpleShare.sln` folder to their solution, reference from their app.
2. Open up your `MainPage.cs` app
  - Add `using Com.Reactlibrary.RNSimpleShare;` to the usings at the top of the file
  - Add `new RNSimpleSharePackage()` to the `List<IReactPackage>` returned by the `Packages` method

## Usage
```javascript
import RNSimpleShare from 'react-native-simple-share';
```

##### Use RNSimpleShare simply by calling:

    RNSimpleShare.showWithOptions({
      text: "Text you want to share",
      url: "URL you want to share",
      imageUrl: "Url of the image you want to share/action",
      imageBase64: "Raw base64 encoded image data"
      image: "Name of the image in the app bundle",
      file: "Path to file you want to share",
      anchor: React.findNodeHandle(this.refs.share), // Where you want the share popup to point to on iPad
    });

##### Note:
- Only provide one image type to the options argument. If multiple image types are provided, image will be used.
- anchor is optional and only applicable for iPad. Popup will be centered by default if anchor is not provided.


## License

MIT
