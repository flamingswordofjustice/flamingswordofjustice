# Ensure url_helpers always have access to polymorphic routes. Wary that
# this may break in future upgrades, but it does seem like a logical default.
Rails.application.routes.url_helpers.send(:extend, ActionDispatch::Routing::PolymorphicRoutes)
