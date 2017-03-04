
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

// TODO: What to do with the module?
RNSimpleShare;
```
  # react-native-simple-share
