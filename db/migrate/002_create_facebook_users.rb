class CreateFacebookUsers < ActiveRecord::Migration
   def self.up
      create_table(:facebook_users, :force => true) do |t|
         t.column(:uid, :integer, :null => false)
         t.column(:session_key, :string )
         t.column(:session_expires, :string)
         t.column(:last_access, :datetime, :default => nil )
         t.timestamps
      end
    
      add_index(:facebook_users, :uid, :unique => true)
      execute 'ALTER TABLE facebook_users MODIFY uid BIGINT NOT NULL;'  rescue nil  # MYSQL Specific there is a plugin for this will it work for sqlite--TODO

   end

   def self.down
      drop_table(:facebook_users)  rescue false
   end
end
