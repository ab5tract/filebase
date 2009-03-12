require 'rubygems'
require 'bacon'
Bacon.extend Bacon::TestUnitOutput
Bacon.summary_on_exit

def test_dir; File.dirname(__FILE__); end

$:.unshift "#{test_dir}/../lib"

require 'filebase'
require 'filebase/drivers/json'
require 'filebase/drivers/yaml'
require 'filebase/drivers/marshal'
require 'filebase/model'