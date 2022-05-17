defmodule TwitterCloneWeb.SettingsView do
  use TwitterCloneWeb, :view
  def new_locale(conn, locale, language_title) do
    "<a href=\"#{Routes.settings_path(conn, :language, locale: locale)}\">#{language_title}</a>" |> raw
  end
end
