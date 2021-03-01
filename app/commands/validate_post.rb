class ValidatePost
  prepend SimpleCommand

  def initialize(post_info)
    @post_info = {
      title: post_info[:title],
      content: post_info[:content]
    }
  end

  def call
    @post_info.each do |key, value|
      if value.nil?
        errors.add :message, "\"#{key}\" is required"
        break
      end
    end
  end
end
