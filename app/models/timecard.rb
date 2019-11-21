# frozen_string_literal: true

class Timecard < ApplicationRecord
  belongs_to :account
  belongs_to :workcode

  with_options numericality: true do
    validates :start_time_h
    validates :start_time_m
    validates :end_time_h
    validates :end_time_m
    validates :overtime_start_time_h
    validates :overtime_start_time_m
    validates :overtime_end_time_h
    validates :overtime_end_time_m
    validates :overtime_total_h
    validates :overtime_total_m
  end
  with_options inclusion: { in: 0..23 } do
    validates :start_time_h
    validates :end_time_h
    validates :overtime_start_time_h
    validates :overtime_end_time_h
    validates :overtime_total_h
  end
  with_options inclusion: { in: 0..59 } do
    validates :start_time_m
    validates :end_time_m
    validates :overtime_start_time_m
    validates :overtime_end_time_m
    validates :overtime_total_m
  end

  # 定数
  CONFIRM = [['未入力', 1], ['休日他', 2], ['承認待', 3], ['差戻し', 4], ['◆', 5]].freeze
  FCONFIRM = [['未入力', 1], ['承認待', 3]].freeze

  def self.find_month(start_month_date, end_month_date)
    find(:all,
         include: [:workcode],
         conditions: ['input_date >=? AND input_date <= ?', start_month_date, end_month_date], order: 'input_date')
  end

  def self.find_month_m(start_month_date, end_month_date)
    find(:all,
         include: %i[workcode user],
         conditions: ['input_date >=? AND input_date <= ?',
           start_month_date, end_month_date], order: 'input_date')
  end

  def self.vacation_sum(start_month_date, end_month_date)
    sum('workcodes.use_time',
        conditions: ['input_date >= ? AND input_date <= ? ', start_month_date, end_month_date],
        joins: 'LEFT JOIN workcodes ON timecards.workcode_id = workcodes.id')
  end

  def self.overtime_total_sum(start_month_date, end_month_date)
    sum('overtime_total',
        conditions: ['input_date >= ? AND input_date <= ? AND confirmation_code = ?', start_month_date, end_month_date, 5])
  end

  before_update :add_actual_time, :add_overtime_total

  def add_actual_time
    total_time = (self.end_time_h * 60 + self.end_time_m) - (self.user.position.work_end_time_h * 60 + self.user.position.work_end_time_m)
      if self.workcode_id == 2 || total_time.positive?
        self.actual_time = total_time
      else
        self.actual_time = 0
      end
  end

  def add_overtime_total
    self.overtime_total = self.overtime_total_h * 60 + self.overtime_total_m
  end

  validates_each :request_date do |model, attr, value|
    if value.nil? && model.workcode_id == 3
      model.errors.add(attr, 'を入力して下さい')
    elsif !value.nil? && (model.workcode_id == 1 || model.workcode_id == 2 || model.workcode_id == 4 || model.workcode_id == 5)
      model.errors.add(attr, 'は入力しないで下さい')
    end
  end
end
