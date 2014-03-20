class Result < ActiveRecord::Base
  belongs_to :calculator

  scope :by_most_recent, -> { order("created_at DESC") }
end
