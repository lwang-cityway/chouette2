require 'spec_helper'

describe "/lines/edit" do
  assign_referential
  let!(:network) { create(:network) }
  let!(:company) { create(:company) }
  let!(:line) { assign(:line, create(:line, :network => network, :company => company)) }
  let!(:lines) { Array.new(2) { create(:line, :network => network, :company => company) } }

  describe "test" do
    it "should render h2 with the group name" do
      render    
      rendered.should have_selector("h2", :text => Regexp.new(line.name))
    end
  end

  describe "form" do
    it "should render input for name" do
      render
      rendered.should have_selector("form") do
        with_tag "input[type=text][name='line[name]'][value=?]", line.name
      end
    end

    it "should render a checkbox for each line" do
      render
      lines.each do |line|
        rendered.should have_selector("form") do
          with_tag "input[type='checkbox'][value=?]", line.id
        end
      end

    end
  end
end
