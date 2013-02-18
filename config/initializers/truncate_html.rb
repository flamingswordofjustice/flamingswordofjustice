TruncateHtml.configure do |config|
  # Truncate on sentence boundaries.
  config.word_boundary = /((?<=[a-z0-9)][.?!])|(?<=[a-z0-9][.?!]"))\s+(?="?[A-Z])/
end
