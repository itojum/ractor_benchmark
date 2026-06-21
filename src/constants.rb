module Constants
  APP_DIR    = "app".freeze
  OUTPUT_DIR = "output".freeze
  TEMPLATE   = <<~ERB.freeze
    <html>
    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width" />
      <title><%= title %></title>
      <meta name="date" content="<%= date %>">
    </head>
      <body>
        <main><%= content %></main>
      </body>
    </html>
  ERB
end
