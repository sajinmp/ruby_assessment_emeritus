module Users
  class Validity
    attr_accessor :kind, :user_id, :error, :valid
    ACTIONS = {student: 'teaching', teacher: 'studying', student_teacher: 'not studying and teaching both'}

    def initialize(kind, user_id)
      @kind = kind
      @user_id = user_id
      send("error=", send("#{kind}_valid?"))
      @valid = error.blank?
    end

  private

    def student_valid?
      add_error if Enrollment.has_teacher?(@user_id)
    end

    def teacher_valid?
      add_error if Enrollment.has_student?(@user_id)
    end

    def student_teacher_valid?
      add_error unless Enrollment.has_teacher?(@user_id) && Enrollment.has_student?(@user_id)
    end

    def add_error
      I18n.t("user.validation.kind_change", kind: @kind, action: ACTIONS[@kind.to_sym])
    end
  end
end
