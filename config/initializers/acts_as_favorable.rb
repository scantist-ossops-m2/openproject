# Be sure to restart your server when you modify this file.

# In development mode, we need to register the acts_as_favorable models manually
# as no eager loading takes place
Rails.application.config.after_initialize do
  if Rails.env.development?
    OpenProject::Acts::Favorable::Registry
      .add(Project)
  end
end
