Pod::Spec.new do |s|
  s.name         = "Envoy"
  s.version      = "1.0.0"
  s.summary      = "Swifty Notification Center"
  s.description  = <<-DESC
    A more Swifty replacement for NSNotificationCenter
  DESC
  s.homepage     = "https://github.com/AirHelp/envoy"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.authors = { "Pawel Dudek" => "pawel@dudek.mobi", "Paweł Kozielecki" => "pawel.kozielecki@airhelp.com" }
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/AirHelp/envoy.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
  s.frameworks  = "Foundation"
end
