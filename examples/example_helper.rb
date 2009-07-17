require 'rubygems'
require 'micronaut'
require 'mocha'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'queued_exceptions'

def not_in_editor?
  !(ENV.has_key?('TM_MODE') || ENV.has_key?('EMACS') || ENV.has_key?('VIM'))
end

Micronaut.configure do |c|
  c.mock_with :mocha
  c.color_enabled = not_in_editor?
  c.filter_run :focused => true
  c.alias_example_to :fit, :focused => true
end
