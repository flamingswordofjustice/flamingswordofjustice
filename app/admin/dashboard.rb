ActiveAdmin.register_page "Dashboard" do
  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    panel "Redirects (24h)" do
      div class: "chart" do
        ul "data-format" => "%I:%M%p", "data-from" => "-24h" do
          li "Redirects/second", "data-target" => "sumSeries(stats.redirects.*)"
        end
      end
    end

    columns do
      column do
        panel "Current listeners" do
          div class: "chart" do
            ul "data-format" => "%I:%M%p", "data-from" => "-6h" do
              li "Published episodes", "data-target" => "sumSeries(stats.gauges.listens.*.published.live)"
              li "Live episodes",      "data-target" => "sumSeries(stats.gauges.listens.*.live.live)"
            end
          end
        end
      end

      column do
        panel "Total listeners" do
          div class: "chart" do
            ul "data-format" => "%I:%M%p", "data-from" => "-6h" do
              li "Published episodes", "data-target" => "sumSeries(stats.gauges.listens.*.published.total)"
              li "Live episodes",      "data-target" => "sumSeries(stats.gauges.listens.*.live.total)"
            end
          end
        end
      end
    end

    # div :class => "blank_slate_container", :id => "dashboard_default_message" do
    #   span :class => "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
