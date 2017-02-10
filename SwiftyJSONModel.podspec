Pod::Spec.new do |s|
  s.name = "SwiftyJSONModel"
  s.version = "0.0.9"
  s.summary = "Better way to use SwiftyJSON with custom models"
  s.homepage = "https://github.com/DKalachniuk/SwiftyJSONModel"
  s.license = { :type => "MIT", :file => "LICENSE.txt" }
  s.authors = { "Oleksii Dykan" => "alickbass@gmail.com"}

  s.ios.deployment_target = "8.0"
  s.requires_arc = true
  s.pod_target_xcconfig =  {
          'SWIFT_VERSION' => '3.0',
    }

  s.source = { :git => "https://github.com/DKalachniuk/SwiftyJSONModel.git", :tag => s.version, :branch => 'master' }
  s.source_files = 'SwiftyJSONModel/*.swift'
  s.dependency 'SwiftyJSON', '~> 3.0'

end
