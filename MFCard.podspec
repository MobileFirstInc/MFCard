Pod::Spec.new do |s|
    s.name             = 'MFCard'
    s.version          = '1.2.5'
    s.summary          = 'Fantastic Credit Card View'
    s.license          = 'MIT'
    s.author           = {'Rahul Chandnani' => 'rahulchandnani@my.com', 'Arpan Desai' => 'arpan@mobilefirst.in'}

    s.source           = { :git => 'https://github.com/MobileFirstInc/MFCard.git' , :tag => '1.2.5'}

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
