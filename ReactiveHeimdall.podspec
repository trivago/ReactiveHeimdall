Pod::Spec.new do |spec|
  spec.name = 'ReactiveHeimdall'
  spec.version = '2.0-alpha.1'
  spec.authors = {
    'Christian Lobach' => 'lobi@rheinfabrik.de'
  }
  spec.license = {
    :type => 'Apache License, Version 2.0',
    :file => 'LICENSE'
  }
  spec.homepage = 'https://github.com/rheinfabrik/ReactiveHeimdall'
  spec.source = {
    :git => 'https://github.com/rheinfabrik/ReactiveHeimdall.git',
    :branch => 'feature/swift-2.0'
  }
  spec.summary = 'Reactive wrapper around Heimdall.swift'
  spec.description = 'ReactiveHeimdall is a ReactiveCocoa-based extension to Heimdall.swift.'

  spec.platform = :ios, '8.0'

  spec.dependency 'Heimdall', '2.0-alpha.1'
  spec.dependency 'ReactiveCocoa', '4.0-alpha.1'
  spec.framework = 'Foundation'

  spec.source_files = 'ReactiveHeimdall/**/*.{h,swift}'
end
