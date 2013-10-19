class Database
  def self.instance
    @database = @database || Database.new
  end
end
