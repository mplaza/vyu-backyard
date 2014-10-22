require 'tzinfo'

class Citytimezone
  include Mongoid::Document
  field :city, type: String
  field :time, type: String

  def self.retrieve_times
  	@dubai = TZInfo::Timezone.get("Asia/Dubai")
	@dubai_local = @dubai.utc_to_local(Time.now.utc)
	@dubai_timezone = Citytimezone.where(city: 'Dubai').first
	@dubai_timezone.update_attribute(:time, @dubai_local)

	@amman = TZInfo::Timezone.get("Asia/Amman")
	@amman_local = @amman.utc_to_local(Time.now.utc)
	@amman_timezone = Citytimezone.where(city: 'Amman').first
	@amman_timezone.update_attribute(:time, @amman_local)

	@la = TZInfo::Timezone.get("America/Los_Angeles")
	@la_local = @la.utc_to_local(Time.now.utc)
	@la_timezone = Citytimezone.where(city: 'Los Angeles').first
	@la_timezone.update_attribute(:time, @la_local)

	@london = TZInfo::Timezone.get("Europe/London")
	@london_local = @la.utc_to_local(Time.now.utc)
	@london_timezone = Citytimezone.where(city: 'London').first
	@london_timezone.update_attribute(:time, @london_local)

  end
end
