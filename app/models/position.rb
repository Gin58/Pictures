# frozen_string_literal: true

class Position < ApplicationRecord
  has_many :accounts, dependent: :destroy

  validates :position_name, presence: true
  with_options numericality: true do
    validates :work_start_time_h
    validates :work_start_time_m
    validates :work_end_time_h
    validates :work_end_time_m
  end
  with_options inclusion: { in: 0..23 } do
    validates :work_start_time_h
    validates :work_end_time_h
  end
  with_options inclusion: { in: 0..59 } do
    validates :work_start_time_m
    validates :work_end_time_m
  end
end
