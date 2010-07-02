require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'mongo_mapper'

module Config
  def setup_db
    Config.setup_db
  end

  def self.setup_db
    MongoMapper.database = 'acts_as_list_test_db'
  end
end 

Config.setup_db

Dir["#{File.dirname(__FILE__)}/models/*.rb"].each {|file| require file}

class Test::Unit::TestCase
  # Drop all collections after each test case.
  def teardown
    # MongoMapper.database.collections.each {|collection| collection.drop }    
    MongoMapper.database.collections.each do |coll|
      coll.drop unless coll.name =~ /(.*\.)?system\..*/
    end    
  end

  # Make sure that each test case has a teardown
  # method to clear the db after each test.
  def inherited(base)
    base.define_method teardown do 
      super
    end
  end
  
  def eql_arrays?(first, second)
    first.collect(&:_id).to_set == second.collect(&:_id).to_set
  end
end
