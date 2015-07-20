
class Sortline < ActiveRecord::Base
 include PgSearch

 pg_search_scope :content, :against => :content

  pg_search_scope :strictly_spelled_like,
                  :against => :content,
                  :using => {
                    :trigram => {
                      :threshold => 0.5
                    }
                  }


  scope :random, -> { order('random()') }


end
