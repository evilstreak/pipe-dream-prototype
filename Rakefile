require 'rubygems'
require 'bundler/setup'
require 'releasy'

Releasy::Project.new do
  name 'Pipe Dream Prototype'
  version '0.2.0'

  executable 'lib/main_window.rb'
  files %w(lib/**/*.rb media/**/*.*)
  add_link 'https://github.com/evilstreak/pipe-dream-prototype', 'Github repo'
  exclude_encoding

  add_build :osx_app do
    # Downloaded from http://www.libgosu.org/downloads/
    wrapper 'wrappers/gosu-mac-wrapper-0.7.44.tar.gz'
    url 'com.dominicbaggott'
    add_package :dmg
  end

  add_build :windows_wrapped do
    # Downloaded from http://rubyinstaller.org/downloads/
    wrapper 'wrappers/ruby-1.9.3-p448-i386-mingw32.7z'
    executable_type :windows
    exclude_tcl_tk
    add_package :zip
  end

  add_deploy :local
end
