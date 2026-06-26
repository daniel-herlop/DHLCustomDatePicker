Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '14.0'
s.name = "DHLCustomDatePicker"
s.summary = "Selector de fecha y hora"
s.requires_arc = true

s.version = "1.0.4"

s.license = { :type => "MIT", :file => "LICENSE" }

s.author = { "Daniel Hernandez Lopez" => "hzlzdaniel@gmail.com" }

s.homepage = "https://github.com/daniel-herlop/DHLCustomDatePicker"

s.source = { :git => "https://github.com/daniel-herlop/DHLCustomDatePicker.git", 
             :tag => "#{s.version}" }

s.framework = "UIKit"

s.source_files = "DHLCustomDatePicker/**/*.{swift}"

#s.resources = "DHLCustomDatePicker/**/*.{png,jpeg,jpg,storyboard,xib,xcassets,strings}"

s.resource_bundles = {
  'DHLCustomDatePickerResources' => [
    'DHLCustomDatePicker/**/*.{png,jpeg,jpg,storyboard,xib,xcassets,strings}'
  ]
}

s.swift_version = "5.0"

end
