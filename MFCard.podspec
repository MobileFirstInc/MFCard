Pod::Spec.new do |s|
    s.name             = 'MFCard'
    s.version          = '1.0'
    s.summary          = 'Fantastic Credit Card View'
    s.license          = 'MIT'
    s.author           = { 'Arpan Desai' => 'arpan@mobilefirst.in' }
    s.source           = { :git => 'https://github.com/MobileFirstInc/MFCard.git', :tag => s.version.to_s }

    s.homepage = 'https://www.mobilefirst.in'
    s.platform     = :ios, '8.0'
    s.requires_arc = true

    s.source_files = 'MFCard/Card /**/*.{swift}'
    s.resource_bundles = {
    'MFCard' => ['MFCard/**/*.{lproj,storyboard,xib,xcassets,json,imageset,png,jpg}']
    }
    s.dependency "RCCreditCardValidator", "~> 0.2.1"
end
