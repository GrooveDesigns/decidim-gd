module Decidim
  module ContentBlocks
    class NavigationPhaseCell < Decidim::ViewModel
      include Decidim::LayoutHelper
      include Browser::ActionController
      include Decidim::ComponentPathHelper
      include ActiveLinkTo
      include Decidim::ParticipatoryProcesses::ParticipatoryProcessHelper
    end
  end
end