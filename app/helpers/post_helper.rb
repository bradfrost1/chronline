module PostHelper

  def byline(post, options={})
    authors = post.authors.sort_by(&:last_name)
    authors.map do |author|
      if options[:link]
        path =
          if post.is_a? Blog::Post
            blog_posts_site_staff_path(author)
          else
            articles_site_staff_path(author)
          end
        link_to author.name, path
      else
        author.name
      end
    end.to_sentence.html_safe
  end

  def display_date(post, format = nil, notime: true)
    publish_date = post.published_at || post.created_at
    datetime_tag(publish_date, format || 'mmmm d, yyyy', timestamp: !notime)
  end

  def disqus_identifier(post)
    if post.is_a? Blog::Post
      # B is for blog post to differentiate identifiers from those of articles
      "B#{post.id}"
    else
      post.previous_id || "_#{post.id}"
    end
  end

  def disqus_options(post)
    {
      production: Rails.env.production?,
      shortname: ENV['DISQUS_SHORTNAME'],
      identifier: disqus_identifier(post),
      title: post.title,
      url: permanent_post_url(post),
    }.to_json
  end

  def beta_post_url(post, options = {})
    if post.is_a? Blog::Post
      polymorphic_url([:beta, post.blog, post], options)
    else
      polymorphic_url([:beta, post], options)
    end
  end

  def beta_post_path(post, options = {})
    options[:routing_type] = :path
    beta_post_url(post, options)
  end

  def site_post_url(post, options = {})
    if post.is_a? Blog::Post
      polymorphic_url([:site, post.blog, post], options)
    else
      polymorphic_url([:site, post], options)
    end
  end

  def site_post_path(post, options = {})
    options[:routing_type] = :path
    site_post_url(post, options)
  end

  def permanent_post_url(post)
    if post.is_a? Blog::Post
      permanent_blog_post_url(post)
    else
      permanent_article_url(post)
    end
  end

end
