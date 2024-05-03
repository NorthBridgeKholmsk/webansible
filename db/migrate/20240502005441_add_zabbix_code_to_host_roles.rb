class AddZabbixCodeToHostRoles < ActiveRecord::Migration[7.0]
  def change
    add_column :host_roles, :zabbix_code, :string
  end
end
