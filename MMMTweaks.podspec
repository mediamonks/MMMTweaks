#
# MMMTweaks. Part of MMMTemple.
# Copyright (C) 2015-2020 MediaMonks. All rights reserved.
#

Pod::Spec.new do |s|

	s.name = "MMMTweaks"
	s.version = "1.0"
	s.summary = "Swift support for Facebook's Tweaks library"
	s.description =  s.summary
	s.homepage = "https://github.com/mediamonks/#{s.name}"
	s.license = "MIT"
	s.authors = "MediaMonks"
	s.source = { :git => "https://github.com/mediamonks/#{s.name}.git", :tag => s.version.to_s }
	
	s.ios.deployment_target = '11.0'
  
  s.dependency 'Tweaks'
	
	s.swift_versions = '4.2'
	s.static_framework = true	
	s.pod_target_xcconfig = {
		"DEFINES_MODULE" => "YES",
		"SWIFT_ACTIVE_COMPILATION_CONDITIONS[config=Debug]" => "TWEAKS_ENABLED"
	}	
  # Unlike our other pods we don't separate specs here, because the only ObjC code here is glueing Tweaks to Swift.
  # The sources are still separated into two folders for SPM's convenience.
	s.source_files = [ "Sources/**/*.{swift,h,m}" ]	
end
