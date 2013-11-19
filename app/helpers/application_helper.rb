module ApplicationHelper
  def page_link_to(title, opts={})
    path = Page.where(title: title).first.try(:slug)
    link_to title, path || "#", opts
  end

  def syndication_link_tag
    content_tag :link, "", rel: "alternate", type: "application/rss+xml", title: t(:tag), href: ENV['PODCAST_URI']
  end

  def twitter_follow(opts={})
    account = opts[:account] || t(:twitter)
    count   = opts[:count]   || false

    raw <<-HTML
      <a href="https://twitter.com/#{account}" class="twitter-follow-button" data-show-count="#{count}" data-size="small" data-show-screen-name="false">Follow @#{account}</a>
    HTML
  end

  def twitter_share(opts={})
    account = opts[:account] || t(:twitter)
    url     = opts[:url] || url_for(:only_path => false)
    text    = html_escape opts[:text]

    raw <<-HTML
      <a href="https://twitter.com/share" class="twitter-share-button" data-via="#{account}" data-text="#{text}" data-url="#{url}" data-counturl="#{url}">Tweet</a>
    HTML
  end

  def twitter_share_attrs(opts={})
    account = opts[:account] || t(:twitter)
    url     = opts[:url] || url_for(:only_path => false)
    text    = html_escape opts[:text]

    { via: account, text: text, url: url, counturl: url }
  end

  def facebook_follow(account=nil)
    account ||= t(:facebook)
    location = "https://www.facebook.com/#{account}"

    content_tag :div, "",
      "class" => "fb-follow",
      "data-href" => location,
      "data-show-faces" => "false",
      "data-layout" => "button_count"
  end

  def facebook_like(url_to_like=nil)
    url_to_like ||= t(:facebook)
    unless url_to_like =~ /http(s?):/
      url_to_like = "https://www.facebook.com/#{url_to_like}"
    end

    content_tag :div, "",
      "class" => "fb-like",
      "data-href" => url_to_like,
      "data-send" => "false",
      "data-width" => 120,
      "data-layout" => "button_count",
      "data-show-faces" => "false"
  end

  def share_subscribe(links)
    render partial: "shared/share_subscribe", locals: links
  end

  def chartbeat_head_tracker
    return nil if chartbeat_uid.blank?

    raw <<-HTML
      <script type="text/javascript">var _sf_startpt=(new Date()).getTime()</script>
    HTML
  end

  def chartbeat_tail_tracker
    return nil if chartbeat_uid.blank?

    raw <<-HTML
      <script type="text/javascript">
        var _sf_async_config = { uid: #{chartbeat_uid}, domain: 'thegoodfight.fm', useCanonical: true };
        (function() {
          function loadChartbeat() {
            window._sf_endpt = (new Date()).getTime();
            var e = document.createElement('script');
            e.setAttribute('language', 'javascript');
            e.setAttribute('type', 'text/javascript');
            e.setAttribute('src','//static.chartbeat.com/js/chartbeat.js');
            document.body.appendChild(e);
          };
          var oldonload = window.onload;
          window.onload = (typeof window.onload != 'function') ?
            loadChartbeat : function() { oldonload(); loadChartbeat(); };
        })();
      </script>
    HTML
  end

  def chartbeat_uid
    ENV['CHARTBEAT_UID']
  end

  def mixpanel_tracker
    if Rails.env.development?
      mixpanel_tracker_debug
    else
      raw <<-HTML
        <script type="text/javascript">
          (function(e,b){if(!b.__SV){var a,f,i,g;window.mixpanel=b;a=e.createElement("script");a.type="text/javascript";a.async=!0;a.src=("https:"===e.location.protocol?"https:":"http:")+'//cdn.mxpnl.com/libs/mixpanel-2.2.min.js';f=e.getElementsByTagName("script")[0];f.parentNode.insertBefore(a,f);b._i=[];b.init=function(a,e,d){function f(b,h){var a=h.split(".");2==a.length&&(b=b[a[0]],h=a[1]);b[h]=function(){b.push([h].concat(Array.prototype.slice.call(arguments,0)))}}var c=b;"undefined"!==typeof d?c=b[d]=[]:d="mixpanel";c.people=c.people||[];c.toString=function(b){var a="mixpanel";"mixpanel"!==d&&(a+="."+d);b||(a+=" (stub)");return a};c.people.toString=function(){return c.toString(1)+".people (stub)"};i="disable track track_pageview track_links track_forms register register_once alias unregister identify name_tag set_config people.set people.set_once people.increment people.append people.track_charge people.clear_charges people.delete_user".split(" ");for(g=0;g<i.length;g++)f(c,i[g]);b._i.push([a,e,d])};b.__SV=1.2}})(document,window.mixpanel||[]);
          mixpanel.init("#{mixpanel_uid}");
        </script>
      HTML
    end
  end

  def mixpanel_tracker_debug
    raw <<-HTML
      <script type="text/javascript">
        window.mixpanel = {
          init:          function(uid) { console.log("mixpanel init", uid); },
          identify:      function(uid) { console.log("mixpanel ident", uid); },
          register_once: function(uid) { console.log("mixpanel r_o", uid); },
          track:         function(what, attrs, done) { console.log("mixpanel track", what, attrs); if (done) { setTimeout(done, 0); } },
          track_forms:   function(query, title, attrs) {
            console.log(
              "mixpanel track form enabled",
              $(query), title,
              typeof(attrs) === "function" ? attrs(query) : attrs
            );
          }
        };
      </script>
    HTML
  end

  def mixpanel_uid
    ENV['MIXPANEL_UID']
  end

  def google_analytics_tracker
    raw <<-HTML
      <script type="text/javascript">
        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', '#{google_analytics_tracking_id}']);
        _gaq.push(['_setDomainName', 'thegoodfight.fm']);
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

  def optimizely_tracker
    return nil if optimizely_project_code.blank?

    raw <<-HTML
      <script src="//cdn.optimizely.com/js/#{optimizely_project_code}.js"></script>
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

  def optimizely_project_code
    ENV["OPTIMIZELY_PROJECT_CODE"]
  end

  def social_icons_for(model, opts={})
    opts[:type] ||= "follow"
    opts[:skip] ||= []
    render partial: 'shared/social_icons', locals: { model: model }.merge(opts)
  end

  def open_graph_and_meta_tags(attrs={})
    attrs[:image]   = asset_path(attrs[:image].present? ? attrs[:image] : "logo.png")
    attrs[:type]  ||= "website"
    attrs[:url]   ||= request.original_url
    attrs[:admin] ||= facebook_admin_id
    attrs[:description] = strip_tags(attrs[:description] || t(:description))

    if attrs[:title].blank?
      attrs[:title] = attrs[:page_title] = t(:tag)
    else
      attrs[:page_title] = [ ( attrs[:page_title] || attrs[:title] ), t(:tag) ].compact.join(" - ")
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

  def facebook_app_secret
    ENV['FACEBOOK_APP_SECRET']
  end

  def comma_separated_list_of(objects, label=:name)
    links = objects.map do |o|
      link_to o.send(label), episodes_path(f: "#{o.class.name.titleize}: #{o.send(label)}".parameterize)
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
            link_to(title, url, title: "Crumb: #{title}", data: { track: "" }) + divider
          end
        end
      end.join.html_safe
    end
  end

  def grouped(title, groups, crumbs)
    render partial: "shared/grouped", locals: { title: title, groups: groups, crumbs: crumbs }
  end

  def subscribe_join_social(opts={})
    opts[:orientation] ||= "vertical"

    render partial: "shared/subscribe_join_social", locals: opts
  end

  def play_controls(opts={})
    if opts[:embed].present? && opts[:episode].present?
      embedded_play_controls opts[:episode]
    else
      partial = opts[:style] == "full" ? "full_play_controls" : "play_controls"

      if opts[:episode].present?
        render partial: "episodes/#{partial}", locals: opts
      end
    end
  end

  def embedded_play_controls(episode)
    content_tag :div, class: "embed-container" do
      content_tag :iframe, "", src: player_url_for(episode), frameborder: 0, allowfullscreen: true, class: "player"
    end
  end

  def page_header(title, attrs={})
    attrs[:crumbs]   ||= []
    attrs[:subtitle] ||= t(:tag)
    attrs[:time]     ||= nil

    render partial: "shared/page_header", locals: attrs.merge(title: title)
  end

  def if_blank(object, *methods)
    methods.inject(nil) { |val, m| val.present? ? val : object.send(m) }
  end

  def canonical_fb_url(object)
    (polymorphic_url(object, protocol: "http", id: object.slug) + "?" + { ref: params[:ref] || "fb", l: params[:l] }.to_query).html_safe
  end

  def canonical_fb_image(object)
    if object.facebook_image_url.present?
      filepicker_image_tag(object.facebook_image_url, w: 403, h: 403)
    else
      object.image.url
    end
  end

  def episode_filters
    Person.with_episodes.all.map {|p| "Guest: #{p.name}"} +
    Topic.order("name").all.map {|t| "Topic: #{t.name}"} +
    Episode.possible_years.map {|y| "Year: #{y}"} +
    Organization.with_episodes.map {|o| "Organization: #{o.name}"}
  end

  def filter_classes_for(episode)
    guests = episode.guests.map {|g|
      type = g.is_a?(Person) ? "Guest" : "Organization"
      "#{type}: #{g.name}"
    }
    topics = episode.topics.map {|t| "Topic: #{t.name}"}
    year   = "Year: #{episode.published_at.year}"

    ( guests + topics + [ year ] ).map(&:parameterize)
  end

end
