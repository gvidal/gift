module Admin::AdminUsersHelper
  def prepare_data_for_table(admin_users)
    OpenStruct.new(:head => [:email, :name], 
                    :content => admin_users.map do |admin_user|
                                OpenStruct.new(:content_methods => [admin_user.email, admin_user.full_name],
                                  :actions => [link_to(t('admin.edit'), edit_admin_admin_user_url(admin_user), :class => "edit"),
                                               link_to(t('admin.destroy'), admin_admin_user_url(admin_user), :method => "destroy", :class => "destroy")])
                                end,
                    :model => AdminUser
    )
  end
  private
  
end
