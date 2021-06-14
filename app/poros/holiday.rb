class Holiday
  attr_reader :holidays
  
  def initialize
    @holidays = HolidayService.validate_connection
  end

  def upcoming_three
    if @holidays.is_a? Array 
     hash = @holidays.each_with_object({}) do |holiday, hash|
        hash[holiday[:name]] = holiday[:date]
      end
    else 
     "Error: Cannot connect to Nager.Date API"
    end
    hash
  end
end