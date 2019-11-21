# frozen_string_literal: true

class Account < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :position
  has_many :vacations, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :timecards, dependent: :destroy

  validates :name, presence: true
  validates :password, length: { within: 6..40 }, on: :create
  # グループマスタ定数
  SECTION = [['るびいすと', 1], ['ぱーりっしゅ', 2]].freeze

  # before_destroy :dont_destroy_admin

  def dont_destroy_admin
    raise '管理者を削除することはできません' if self.full_name == 'るびま'
  end

  def self.authenticate(login, pass)
    find_first(['login = ? AND password = ?', login, sha1(pass)])
  end

  def self.authenticate?(login, pass)
    user = self.authenticate(login, pass)
    return false if user.nil?
    return true if user.login == login

    false
  end

  protected

  def self.sha1(pass)
    Digest::SHA1.hexdigest("rubima--#{pass}--")
  end

  before_create :crypt_password

  def crypt_password
    write_attribute('password', self.class.sha1(password))
  end

  before_update :crypt_unless_empty

  def crypt_unless_empty
    if password.empty?
      user = self.class.find(self.id)
      self.password = user.password
    else
      write_attribute 'password', self.class.sha1(password)
    end
  end
end
