# -*- coding:utf-8 -*-
# == Schema Information
#
# Table name: users
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  provider    :string(255)
#  screen_name :string(255)
#  uid         :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class User < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  validates :screen_name, :presence => true, :uniqueness => true
  has_many :strategies, :dependent => :destroy
  paginates_per 15
  default_scope {order(updated_at: :desc)}

  def self.create_with_omniauth(auth)
#    begin
      create! do |user|
        user.provider = auth["provider"]
        user.uid = auth["uid"]
        user.screen_name = auth["info"]["nickname"]
        user.name = auth["info"]["name"]
      end
#    rescue Exception => exception
#ActiveRecord::RecordInvalid
#      raise exception
#    end
  end

end
