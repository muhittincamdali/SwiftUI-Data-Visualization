Pod::Spec.new do |s|
  s.name             = 'SwiftUIDataVisualization'
  s.version          = '1.0.0'
  s.summary          = 'Charts and data visualization components for SwiftUI.'
  s.description      = <<-DESC
    SwiftUIDataVisualization provides beautiful charts and data visualization
    components for SwiftUI. Features include line charts, bar charts, pie charts,
    scatter plots, heatmaps, real-time updates, animations, and accessibility support.
  DESC

  s.homepage         = 'https://github.com/muhittincamdali/SwiftUI-Data-Visualization'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Muhittin Camdali' => 'contact@muhittincamdali.com' }
  s.source           = { :git => 'https://github.com/muhittincamdali/SwiftUI-Data-Visualization.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'
  s.osx.deployment_target = '12.0'
  s.tvos.deployment_target = '15.0'
  s.watchos.deployment_target = '8.0'

  s.swift_versions = ['5.9', '5.10', '6.0']
  s.source_files = 'Sources/**/*.swift'
  s.frameworks = 'Foundation', 'SwiftUI'
end
