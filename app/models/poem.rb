class Poem < ActiveRecord::Base
  scope :random, -> { order('random()') }

  searchable do
    text :title, :content
    time    :created_at
    time    :updated_at
    string  :sort_title do
      title.downcase.gsub(/^(an?|the)/, '')
    end
  end

end
