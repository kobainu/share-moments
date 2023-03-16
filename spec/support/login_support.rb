module LoginSupport
  def login(user)
    visit root_path
    click_link 'ログイン'
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end
end
