# frozen_string_literal: true

require "webpacker"

ENV["RAILS_ENV"] = Hanami.env

# Rails.env isn't available
# Monkeypatch Webpacker::Env#current
class Webpacker::Env
  def current
    available_environments.include?(Hanami.env) ? Hanami.env : nil
  end
end

# Rails.env isn't available
# Monkeypatch Webpacker::Compiler#default_watched_paths
class Webpacker::Compiler
  def default_watched_paths
    [
      *config.resolved_paths_globbed,
      "#{config.source_path.relative_path_from(Hanami.root)}/**/*",
      "yarn.lock",
      "package.json",
      "config/webpack/**/*"
    ].freeze
  end

  def webpack_env
    env
  end
end

# Overwrite default webpacker instance using Hanami.root
Webpacker.instance = Webpacker::Instance.new(
  root_path: Hanami.root,
  config_path: Hanami.root.join("config", "webpacker.yml")
)
