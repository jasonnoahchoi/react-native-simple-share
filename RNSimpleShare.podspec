require 'json'
version = JSON.parse(File.read('package.json'))["version"]

Pod::Spec.new do |s|
  s.name           = "RNSimpleShare"
  s.version        = version
  s.summary        = "Simple iOS share UIActivityViewController for React Native"
  s.description    = "Simple iOS share UIActivityViewController for React Native"
  s.homepage       = "https://github.com/jasonnoahchoi/react-native-simple-share"
  s.license        = "MIT"
  s.author         = { "Jason Noah Choi" => "jasonnoahchoi@gmail.com" }
  s.platform       = :ios, "8.0"
  s.source         = { :git => "https://github.com/jasonnoahchoi/react-native-simple-share.git", :tag => "v#{s.version}" }
  s.source_files   = "RNSimpleShare/*.{h,m}"
  s.requires_arc   = true
  s.preserve_paths = "**/*.js"


  s.dependency "React"
  #s.dependency "others"

end
