use Mix.Config

import_config "config.secret.exs"
import_config "#{Mix.env()}.exs"
