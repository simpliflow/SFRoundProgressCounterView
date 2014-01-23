Pod::Spec.new do |spec|
  spec.name 			= 'SFRoundProgressCounterView'
  spec.version 			= '0.0.1'
  spec.summary			= 'Provides a progress bar as circle with an optional counter in the center of the circle'
  spec.platform 		= :ios
  spec.license			= 'MIT'
  spec.ios.deployment_target 	= '7.0'
  spec.authors			= 'Thomas Winkler'
  spec.source_files 		= 'SFRoundProgressCounterView/*.{h,m}'  
  spec.framework  = 'UIKit'
  spec.requires_arc = true

  spec.dependency 'TTTAttributedLabel', '~> 1.7.1'
end
