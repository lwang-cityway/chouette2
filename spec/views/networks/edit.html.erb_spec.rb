require 'spec_helper'

describe "/networks/edit" do
  let!(:referential) { assign(:referential, Factory(:referential)) }
  let!(:network) { assign(:network, Factory(:network) ) }
  let!(:networks) { Array.new(2) { Factory(:network) } }

  describe "test" do
    it "should render h2 with the group name" do
      render    
      rendered.should have_selector("h2", :text => Regexp.new(network.name))
    end
  end

  describe "form" do
    it "should render input for name" do
      render
      rendered.should have_selector("form") do
        with_tag "input[type=text][name='network[name]'][value=?]", network.name
      end
    end

    it "should render a checkbox for each network" do
      render
      networks.each do |network|
        rendered.should have_selector("form") do
          with_tag "input[type='checkbox'][value=?]", network.id
        end
      end

    end
  end
end
