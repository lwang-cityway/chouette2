require 'spec_helper'

describe VehicleTranslation do
  let!(:company){ Factory(:company )}
  let!(:journey_pattern){Factory(:journey_pattern)}
  let!(:vehicle_journey){ Factory(:vehicle_journey, 
                                  :objectid => "dummy",
                                  :journey_pattern => journey_pattern,
                                  :route => journey_pattern.route,
                                  :company => company,
                                  :transport_mode => Chouette::TransportMode.new("metro"), 
                                  :published_journey_name => "dummy"
                                  )}
  subject {Factory.build(:vehicle_translation, :vehicle_journey_id => vehicle_journey.id)}

  describe "#translate" do
    it "should add new vehicle" do
      count_before = Chouette::VehicleJourney.count
      subject.translate
      count_after = Chouette::VehicleJourney.count
      count_after.should == count_before + subject.count.to_i
    end
    def last_created_vehicle
      Chouette::VehicleJourney.find( :all, :order => :creation_time).last
    end
    it "should add vehicle having same published_journey_name" do
      subject.translate
      last_created_vehicle.published_journey_name.should == vehicle_journey.published_journey_name
    end
    it "should add vehicle having same transport_mode" do
      subject.translate
      last_created_vehicle.transport_mode.should == vehicle_journey.transport_mode 
    end
    it "should add vehicle having same journey_pattern" do
      subject.translate
      last_created_vehicle.journey_pattern.should == vehicle_journey.journey_pattern 
    end
    it "should add vehicle having same route" do
      subject.translate
      last_created_vehicle.route.should == vehicle_journey.route 
    end
    it "should add vehicle having same company" do
      subject.translate
      last_created_vehicle.company.should == vehicle_journey.company 
    end
    it "should add vehicle with as many vehicle_journey_at_stops as on basic vehicle" do
      subject.translate
      last_created_vehicle.vehicle_journey_at_stops.count.should == vehicle_journey.vehicle_journey_at_stops.count
    end
    it "should add vehicle where vehicle_journey_at_stops are translated with #duration" do
      read_vehicle = Chouette::VehicleJourney.find(vehicle_journey.id)  # read from bd, change time values
      subject.translate
      last_created_vehicle.vehicle_journey_at_stops.each_with_index do |vjas, index|
        vjas.departure_time.should == (read_vehicle.vehicle_journey_at_stops[index].departure_time + subject.duration.minutes)
        vjas.arrival_time.should == (read_vehicle.vehicle_journey_at_stops[index].arrival_time + subject.duration.minutes)
      end
    end
  end
end

