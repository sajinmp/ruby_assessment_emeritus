class Enrollment < ApplicationRecord
  belongs_to :user, foreign_key: :user_id
  belongs_to :teacher, foreign_key: :teacher_id, class_name: 'User'
  belongs_to :program

  class << self
    def has_student?(id)
      find_by("user_id = ?", id).present?
    end

    def has_teacher?(id)
      find_by("teacher_id = ?", id).present?
    end
  end
end
