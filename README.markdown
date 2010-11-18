Install
=========
<code>
rake tabulator:install
</code>

Uninstall
=========
<code>
rake tabulator:uninstall
</code>


Example
=======
<code>
<% content_for :head do %>
  <%= tabulator_init %>
<% end %>

<%= tabulator do |t| %>
  <% t.tab(:id => :one, :name => "One") do %>
    Some text
  <% end %>
  <% t.tab({:id => :two, :name => "Two", :active = true}, render(:partial => "some_template", :locals => {})) %>
  <% t.tab({:id => :three, :name => "Three"}, "Some text") %>
  <% t.status("Some status text")
<% end %>
</code>

Copyright (c) 2010 undr, released under the MIT license
