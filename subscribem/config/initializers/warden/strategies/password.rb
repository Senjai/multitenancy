Warden::Strategies.add(:password) do
  def valid?
    host = request.host
    subdomain = ActionDispatch::Http::URL.extract_subdomains(host, 1)
    subdomain.present? && params['user']
  end

  def authenticate!
    u = Subscribem::User.find_by_email(params["user"]["email"])
    if u.nil?
      fail!
    else
      if u.authenticate(params['user']['password'])
        success!(u)
      else
        fail!
      end
    end
  end
end