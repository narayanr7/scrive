abstract class ApiAction < Lucky::Action
  # Remove this line if you want to send cookies in the response header.
  disable_cookies
  accepted_formats [:json]
end
