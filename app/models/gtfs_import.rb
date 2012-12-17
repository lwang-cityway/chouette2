class GtfsImport < Import

  validates_presence_of :objectid_prefix
  option :objectid_prefix

  def import_options
    super.merge(:format => :gtfs, :objectid_prefix => objectid_prefix)
  end

end
