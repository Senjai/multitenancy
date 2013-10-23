Forem::ApplicationController.class_eval do
  before_filter :authenticate_user!
end