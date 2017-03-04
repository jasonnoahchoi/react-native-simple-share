require 'json'
version = JSON.parse(File.read('package.json'))["version"]

Pod::Spec.new do |s|
  s.name           = "RNSimpleShare"
  s.version        = version
  s.summary        = "RNSimpleShare"
  s.description    = <<-DESC
                     RNSimpleShare
                     DESC
  s.homepage       = ""
  s.license        = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author         = { { "Jason Noah Choi" => "jasonnoahchoi@gmail.com" } }
  s.platform       = :ios, "7.0"
  s.source         = { :git => "https://github.com/jasonnoahchoi/RNSimpleShare.git", :tag => "master" }
  s.source_files   = "RNSimpleShare/**/*.{h,m}"
  s.requires_arc   = true
  s.preserve_paths = "**/*.js"


  s.dependency "React"
  #s.dependency "others"

end

  