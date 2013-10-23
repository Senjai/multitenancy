Subscribem::User.class_eval do
  def forem_settings
    @settings ||= Forem::UserSettings.where(user_id: self.id).first_or_create
  end

  [:forem_admin, :forem_auto_subscribe, :forem_state].each do |method|
    class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
      def #{method}=(value)
        forem_settings.update_column(:#{method}, value)
      end

      def #{method}
        forem_settings.#{method}
      end
    RUBY_EVAL
  end

  alias_method :forem_admin?, :forem_admin
  alias_method :forem_auto_subscribe?, :forem_auto_subscribe
end