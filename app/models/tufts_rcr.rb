require "hydra"

# 2011-10-05
#
# My take on what our record creator record content model is going to look like
# in ActiveFedora
#
# Since we're new to activefedora rather than drive yourself nuts make sure to read
# the rdoc on activefedora: http://rdoc.info/github/mediashelf/active_fedora/master/file/README.textile#
#


class TuftsRCR < ActiveFedora::Base

  include Hydra::ModelMethods
  include Tufts::ModelMethods

  # I haven't quite worked out how this works or if its relevant for us.
  #has_relationship "parts", :is_part_of, :inbound => true

  # Uses the Hydra Rights Metadata Schema for tracking access permissions & copyright
  has_metadata :name => "rightsMetadata", :type => TuftsRightsMetadata

  # Tufts specific needed metadata streams
  has_metadata :name => "DCA-META", :type => TuftsDcaMeta
  has_metadata :name => "DCA-ADMIN", :type => TuftsAdministrativeMeta
  has_metadata :name => "DC-DETAILED", :type => TuftsDcDetailed

  # DCA_admin might be the one that we have started clearing out -- it used to have metadata
  # but it was all wrong, so now we're just putting it in as empty.
  #has_metadata :name => "DCA-ADMIN", :type => ActiveFedora::Datastream


  #MK 2011-04-13 - Are we really going to need to access FILE-META from FILE-META.  I'm guessing
  # not.
  has_metadata :name => "FILE-META", :type => TuftsFileMeta

  #Our Binary streams
  #has_datastream :name=>"Access.xml", :type=>ActiveFedora::Datastream, :controlGroup=>'E'
  #has_datastream :name=>"Archival.pdf", :type=>ActiveFedora::Datastream, :controlGroup=>'E'

  has_metadata :name => "RCR-CONTENT", :type => TuftsRcrMeta

  #def initialize()
  ##    super()
  #    ds = ActiveFedora::Datastream.new(:dsid=> "Access.xml", :label => "Access.xml", :controlGroup => "M", :dsLocation => "", :mimeType=> "text/xml")
  ##    add_datastream(ds)
  #   ds = ActiveFedora::Datastream.new(:dsid=> "Archival.pdf", :label => "Archival.pdf", :controlGroup => "M", :dsLocation => "", :mimeType=> "text/xml")
  #   add_datastream(ds)
  #end
  def to_solr(solr_doc=Hash.new, opts={})
    super
    models = self.relationships(:has_model)
    unless models.include?("info:fedora/cm:Text.RCR") || models.include?("info:fedora/afmodel:TuftsRCR")
      create_facets(self, solr_doc)
    end

    index_sort_fields self,solr_doc

    index_fulltext self, solr_doc

    return solr_doc
  end

end
