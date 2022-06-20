defmodule TwitterCloneWeb.Router do
  use TwitterCloneWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TwitterCloneWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug TwitterCloneWeb.Plugs.Locale
    plug TwitterCloneWeb.Plugs.CurrentUserPlug
  end

  pipeline :auth do
    plug TwitterCloneWeb.Pipeline
  end

  pipeline :allowed_for_users do
    plug TwitterCloneWeb.Plugs.AuthorizationPlug, ["User", "Admin"]
  end

  pipeline :allowed_for_admin do
    plug TwitterCloneWeb.Plugs.AuthorizationPlug, ["Admin"]
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :ensure_no_auth do
    plug Guardian.Plug.EnsureNotAuthenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug TwitterCloneWeb.Plugs.ApiPlug
  end

  scope "/", TwitterCloneWeb do
    pipe_through [:browser, :auth, :ensure_no_auth]

    get "/login", SessionController, :new
    post "/login", SessionController, :login

    get "/register", UserController, :new
    post "/register", UserController, :create
  end



  #when user is logged in
  scope "/", TwitterCloneWeb do
    pipe_through [:browser, :auth, :ensure_auth]



    get "/", PostController, :index
    get "/logout", SessionController, :logout

    resources "/posts", PostController

    resources "/users" , UserController

    resources "/comments", CommentController


    get "/search", UserController, :search

    get "/settings", SettingsController, :index


  end



  scope "/settings", TwitterCloneWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    get "/", SettingsController, :index
    get "/theme", SettingsController, :theme
    get "/language", SettingsController, :language

    get "/token", SettingsController, :token
    get "/generateToken", SettingsController, :generateToken
  end

  scope "like", TwitterCloneWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    post "/:post_id", LikeController, :create
    delete "/:post_id", LikeController, :delete
  end

  scope "/:id", TwitterCloneWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    get "/edit", UserController, :edit
    get "/editProfile", UserController, :editProfile

    put "/edit", UserController, :update
    put "/editUser", UserController, :updateUser

    get "/", UserController, :show

    get "/followers", UserController, :followers
    get "/following", UserController, :following

    post "/", UserController, :create_relation
    delete "/", UserController, :delete_relation
  end

  scope "/api/public", TwitterCloneWeb do
    pipe_through :api

    resources "/users" , UserRestPublicController, only: [:index, :create]
  end

  scope "/api/private", TwitterCloneWeb do
    pipe_through [:api, :authenticate_api_user]

    resources "/users" , UserRestPrivateController
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TwitterCloneWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
