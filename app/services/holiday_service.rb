class HolidayService

  def self.validate_connection
    response = Faraday.get('https://date.nager.at/api/v2/NextPublicHolidays/us')
    json = JSON.parse(response.body, symbolize_names: true)
    json[0..2]
  end
end
