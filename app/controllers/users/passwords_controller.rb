class Users::PasswordsController < Devise::PasswordsController
   def new
    @hide_navbar = true
    @hide_sidebar = true
     super
   end
end
