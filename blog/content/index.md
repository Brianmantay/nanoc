---
title: Blog
---

<% sorted_articles.each do |post| %>
  <div class='post'>
    <h1><%= link_to post[:title], post.path %></h1>
    <aside>Posted at: <%= post[:created_at] %></aside>
    <article>
      <%= post.compiled_content %>
    </article>
  </div>
<% end %>

