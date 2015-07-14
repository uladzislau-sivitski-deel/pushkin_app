require 'elasticsearch/model'

class Poem < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks


  scope :random, -> { order('random()') }


end
