class AuthenticateUser
  prepend SimpleCommand

  def initialize(email, password)
    @user_info = {
      email: email,
      password: password
    }
  end

  def call
    JsonWebToken.encode(user_id: user.id) if user
  end

  private

  def user
    validate_fields
    return nil if errors.present?

    user = User.find_by(email: @user_info[:email])

    user&.authenticate(@user_info[:password]) ? user : errors.add(:message, 'Campos inválidos')
  end

  def validate_fields
    @user_info.each do |key, value|
      if value.nil?
        errors.add :message, "\"#{key}\" is required"
        break
      elsif value.empty?
        errors.add :message, "\"#{key}\" is not allowed to be empty"
        break
      end
    end
  end
end
