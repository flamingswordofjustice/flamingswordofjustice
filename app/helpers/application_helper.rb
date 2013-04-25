module ApplicationHelper
  def page_link_to(title, opts={})
    path = Page.where(title: title).first.try(:slug)
    link_to title, path || "#", opts
  end

  def syndication_link_tag
    content_tag :link, "", rel: "alternate", type: "application/rss+xml", title: t(:tag), href: "http://example.com/rss"
  end

  def twitter_follow(opts={})
    account = opts[:account] || t(:twitter)
    count   = opts[:count]   || false

    raw <<-HTML
      <a href="https://twitter.com/#{account}" class="twitter-follow-button" data-show-count="#{count}" data-size="small" data-show-screen-name="false">Follow @#{account}</a>
      <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
    HTML
  end

  def twitter_share(opts={})
    account = opts[:account] || t(:twitter)
    url     = opts[:url] || url_for(:only_path => false)
    text    = html_escape opts[:text]

    raw <<-HTML
      <a href="https://twitter.com/share" class="twitter-share-button" data-via="#{account}" data-text="#{text}" data-url="#{url}">Tweet</a>
      <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
    HTML
  end

  def facebook_follow(account=nil)
    account ||= t(:facebook)
    raw <<-HTML
      <div class="fb-follow" data-href="https://www.facebook.com/#{account}" data-show-faces="false" data-layout="button_count"></div>
    HTML
  end

  def facebook_like(url_to_like=nil)
    url_to_like ||= "flamingswordofjustice"
    unless url_to_like =~ /http(s?):/
      url_to_like = "https://www.facebook.com/#{url_to_like}"
    end

    raw <<-HTML
      <div class="fb-like" data-href="#{url_to_like}" data-send="false" data-width="120" data-layout="button_count" data-show-faces="false"></div>
    HTML
  end

  def livefyre_comments
    raw <<-HTML
    <div id="livefyre-comments"></div>
      <script type="text/javascript" src="http://zor.livefyre.com/wjs/v3.0/javascripts/livefyre.js"></script>
      <script type="text/javascript">
      (function () {
          var articleId = fyre.conv.load.makeArticleId(null);
          fyre.conv.load({}, [{
              el: 'livefyre-comments',
              network: "livefyre.com",
              siteId: "#{ENV['LIVEFYRE_SITE_ID']}",
              articleId: articleId,
              signed: false,
              collectionMeta: {
                  articleId: articleId,
                  url: fyre.conv.load.makeCollectionUrl(),
              }
          }], function() {});
      }());
      </script>
    HTML
  end

  def facebook_script
    raw <<-HTML
      <div id="fb-root"></div>
      <script>(function(d, s, id) {
        var js, fjs = d.getElementsByTagName(s)[0];
        if (d.getElementById(id)) return;
        js = d.createElement(s); js.id = id;
        js.src = "//connect.facebook.net/en_US/all.js#xfbml=1&appId=#{facebook_app_id}";
        fjs.parentNode.insertBefore(js, fjs);
      }(document, 'script', 'facebook-jssdk'));</script>
    HTML
  end

  def google_analytics_tracker
    raw <<-HTML
      <script type="text/javascript">
        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', '#{google_analytics_tracking_id}']);
        _gaq.push(['_setDomainName', 'flamingswordofjustice.com']);
        _gaq.push(['_trackPageview']);

        (function() {
          var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
          ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
          var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();
      </script>
    HTML
  end

  def internet_defense_league
    raw <<-HTML
      <script type="text/javascript">
        window._idl = {};
        _idl.variant = "banner";
        (function() {
            var idl = document.createElement('script');
            idl.type = 'text/javascript';
            idl.async = true;
            idl.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'members.internetdefenseleague.org/include/?url=' + (_idl.url || '') + '&campaign=' + (_idl.campaign || '') + '&variant=' + (_idl.variant || 'banner');
            document.getElementsByTagName('body')[0].appendChild(idl);
        })();
      </script>
    HTML
  end

  def itunes_link
    ENV['ITUNES_URI']
  end

  def podcast_link
    ENV['PODCAST_URI']
  end

  def listener_tracking_uri
    ENV["LISTENER_TRACKING_URI"]
  end

  def social_icons_for(model, opts={})
    opts[:type] ||= "follow"
    render partial: 'shared/social_icons', locals: { model: model }.merge(opts)
  end

  def open_graph_and_meta_tags(attrs={})
    attrs[:image] ||= image_path("sword.png")
    attrs[:type]  ||= "website"
    attrs[:url]   ||= request.original_url
    attrs[:admin] ||= facebook_admin_id
    attrs[:description] = strip_tags(attrs[:description] || t(:description))

    if attrs[:title].blank?
      attrs[:title] = attrs[:page_title] = t(:tag)
    else
      attrs[:page_title] = [ t(:tag), ( attrs[:page_title] || attrs[:title] ) ].compact.join(" - ")
    end

    content_for :head do
      render partial: 'shared/open_graph', locals: attrs
    end
  end

  def google_analytics_tracking_id
    ENV['GOOGLE_ANALYTICS_TRACKING_ID']
  end

  def facebook_admin_id
    ENV['FACEBOOK_ADMIN_ID']
  end

  def facebook_app_id
    ENV['FACEBOOK_APP_ID']
  end

  def comma_separated_list_of(objects, label=:name)
    links = objects.map do |o|
      link_to o.send(label), url_for(o)
    end

    safe_join links, ", "
  end

  def divider(columns=12)
    render partial: 'shared/divider', locals: { cols: columns }
  end

  def breadcrumb_for(crumb)
    if crumb.is_a?(Array)
      crumb
    elsif crumb == :root
      ["Home", root_path]
    elsif crumb.respond_to?(:model_name)
      ["All #{crumb.model_name.pluralize}", url_for(crumb)]
    elsif crumb.respond_to?(:name)
      [crumb.name, url_for(crumb)]
    elsif crumb.respond_to?(:title)
      [crumb.title, url_for(crumb)]
    elsif crumb.to_s =~ /by_(\w+)/
      ["By #{$1.titleize}", grouped_episodes_path($1)]
    else
      raise "Can't construct breadcrumb from #{crumb}"
    end
  end

  def breadcrumbs(*crumbs)
    divider = content_tag :span, class: :divider do
      content_tag(:i, "", class: "icon-double-angle-right")
    end

    content_tag :ul, class: "breadcrumb" do
      crumbs.map.with_index do |crumb, i|
        if i == crumbs.length - 1
          content_tag :li, class: "active" do
            title, url = breadcrumb_for(crumb)
            title
          end
        else
          content_tag :li do
            title, url = breadcrumb_for(crumb)
            link_to(title, url) + divider
          end
        end
      end.join.html_safe
    end
  end

  def grouped(title, groups, crumbs)
    render partial: "shared/grouped", locals: { title: title, groups: groups, crumbs: breadcrumbs(*crumbs) }
  end

  def comments_enabled?
    !Rails.env.development?
  end

  def subscribe_join_social(opts={})
    opts[:orientation] ||= "vertical"

    render partial: "shared/subscribe_join_social", locals: opts
  end

  def play_controls(opts={})
    partial = opts[:style] == "full" ? "full_play_controls" : "play_controls"

    if opts[:episode].present? && opts[:episode].visible?
      render partial: "episodes/#{partial}", locals: opts
    end
  end
end
