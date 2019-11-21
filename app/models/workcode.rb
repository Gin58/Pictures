# frozen_string_literal: true

class Workcode < ApplicationRecord
  has_many :timecards, dependent: :destroy
end
