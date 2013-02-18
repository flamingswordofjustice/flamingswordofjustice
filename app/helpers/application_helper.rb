module ApplicationHelper
  def page_link_to(title, opts={})
    path = Page.where(title: title).first.try(:slug)
    link_to title, path || "#", opts
  end

  def twitter_follow
    raw <<-HTML
      <a href="https://twitter.com/flamingjustice" class="twitter-follow-button" data-show-count="false" data-size="small" data-show-screen-name="false">Follow @flamingjustice</a>
      <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
    HTML
  end

  def twitter_big_follow
    raw <<-HTML
      <a href="https://twitter.com/flamingjustice" class="twitter-follow-button" data-show-count="false" data-size="large">Follow @flamingjustice</a>
      <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
    HTML
  end

  def facebook_follow
    raw <<-HTML
      <div class="fb-follow" data-href="https://www.facebook.com/flamingswordofjustice" data-show-faces="false" data-layout="button_count"></div>
    HTML
  end

  def facebook_script
    raw <<-HTML
      <div id="fb-root"></div>
      <script>(function(d, s, id) {
        var js, fjs = d.getElementsByTagName(s)[0];
        if (d.getElementById(id)) return;
        js = d.createElement(s); js.id = id;
        js.src = "//connect.facebook.net/en_US/all.js#xfbml=1&appId=158508567636870";
        fjs.parentNode.insertBefore(js, fjs);
      }(document, 'script', 'facebook-jssdk'));</script>
    HTML
  end

  def itunes_link
    "https://itunes.apple.com/us/podcast/flaming-sword-justice-ben/id497260543"
  end
end
