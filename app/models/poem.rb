
class Poem < ActiveRecord::Base
 include PgSearch
 pg_search_scope :content, :against => :content
  scope :random, -> { order('random()') }


end
