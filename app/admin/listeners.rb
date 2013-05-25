ActiveAdmin.register_page "Listeners" do

  content :title => proc{ I18n.t("active_admin.listeners") } do
    table class: "listeners index_table index", "data-tracking-uri" => listener_tracking_uri do
      thead do
        tr do
          th "Start Time"
          th "Total Listen Time"
          th "Episode ID"
          th "Referrer"
          th "Play state"
          th "Episode State"
        end
      end

      tbody "data-bind" => "foreach: listeners" do
        tr "class" => "summary", "data-bind" => "click: toggle, css: { active: isVisible }" do
          td "", "data-bind" => "text: startTimeFormatted", style: "border-bottom: 0"
          td "", "data-bind" => "text: listenTimeFormatted", style: "border-bottom: 0"
          td "", "data-bind" => "text: episodeId", style: "border-bottom: 0"
          td "", "data-bind" => "text: ref", style: "border-bottom: 0"
          td "", "data-bind" => "text: state", style: "border-bottom: 0"
          td "", "data-bind" => "text: episodeState", style: "border-bottom: 0"
        end
        tr "class" => "details", "data-bind" => "click: toggle, visible: isVisible, css: { active: isVisible }" do
          td colspan: 6 do
            table do
              thead do
                tr do
                  td "Event"
                  td "General type"
                  td "Timestamp"
                  td "Time elapsed"
                  td "Time played"
                end
              end
              tbody "data-bind" => "foreach: listens" do
                tr do
                  td "", "data-bind" => "text: event"
                  td "", "data-bind" => "text: type"
                  td "", "data-bind" => "text: strftime('%T', new Date(timestamp))"
                  td "", "data-bind" => "text: strftimeUTC('%T', new Date(elapsed))"
                  td "", "data-bind" => "text: strftimeUTC('%T', new Date(played))"
                end
              end
            end
          end
        end
      end
    end
  end

  sidebar "Filter" do
    select class: "episode" do
      option "All Episodes", value: ""
      Episode.all.each do |e|
        option e.title, value: e.slug
      end
    end
  end

  # sidebar "More Details", class: "foo" do
  #   div "data-bind" => "with: activeListener" do
  #     h1 "", style: "text-align: center", "data-bind" => "text: listenTimeFormatted"

  #     table do
  #       tr { th "Session ID" }
  #       tr { td "", "data-bind" => "text: sessionId" }

  #       tr { th "Plays" }
  #       tr do
  #         td do
  #           dl "data-bind" => "foreach: listens" do
  #             dt "", "data-bind" => "text: event"
  #             dd "", "data-bind" => "text: timestamp"
  #           end
  #         end
  #       end
  #     end
  #   end
  # end

end
