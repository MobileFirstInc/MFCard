Pod::Spec.new do |s|
    s.name             = 'MFCard'
    s.version          = '1.2'
    s.summary          = 'Fantastic Credit Card View'
    s.license          = 'MIT'
    s.author           = { 'Arpan Desai' => 'arpan@mobilefirst.in', 'Rahul Chandnani' => 'rahulchandnani@my.com'}
    s.source           = { :git => 'https://github.com/MobileFirstInc/MFCard.git' }

    s.homepage = 'https://www.mobilefirst.in'
    s.platform     = :ios, '8.0'
    s.requires_arc = true

    s.source_files = 'MFCard/**/*.{swift,h}'
    s.resource_bundles = {
    'MFCard' => ['MFCard/**/*.{xib,xcassets,json,imageset,png,jpg}']
    }
    s.frameworks = 'UIKit', 'Foundation'
    s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }
end
