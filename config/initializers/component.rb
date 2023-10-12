# frozen_string_literal: true

# コンポーネントのattributeを変更する
Decidim.find_component_manifest(:proposals).settings(:global) do |settings|
  settings.attribute :proposal_length, type: :integer, default: 5000
  settings.attribute :proposal_edit_time, type: :enum, default: "infinite", choices: -> { %w(limited infinite) }
  settings.attribute :attachments_allowed, type: :boolean, default: true
end

Decidim.find_component_manifest(:proposals).settings(:step) do |settings|
  settings.attribute :votes_enabled, type: :boolean, default: true
  settings.attribute :endorsements_enabled, type: :boolean, default: false
  settings.attribute :creation_enabled, type: :boolean, default: true
end
