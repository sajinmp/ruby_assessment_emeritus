class User < ApplicationRecord
  enum kind: [:student, :teacher, :student_teacher]

  has_many :enrollments
  has_many :teachers, -> { distinct }, through: :enrollments, class_name: 'User'
  has_many :favorite_teachers, -> { where(enrollments: {favorite: true}).distinct }, through: :enrollments, source: :teacher, class_name: 'User'

  validate :kind_change, if: :kind_changed?

  class << self
    def classmates(user)
      user_ids = Enrollment
        .where(program_id: user.enrollments.pluck(:program_id))
        .where.not(user_id: user.id).pluck(:user_id)
      User.where(id: user_ids)
    end
  end

private

  def kind_change
    user_validity = Users::Validity.new(kind, id)
    errors.add :kind, user_validity.error unless user_validity.valid
  end
end
